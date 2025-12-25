locals {
  merged_tags = merge(var.tags, {
    Name = var.name
  })
}

data "aws_kms_alias" "rds" {
  count = var.storage_encrypted && var.kms_key_id == null ? 1 : 0
  name  = "alias/aws/rds"
}

resource "aws_db_subnet_group" "this" {
  name       = var.name
  subnet_ids = var.private_subnet_ids
  tags       = local.merged_tags
}

resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Security group for ${var.name} RDS"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_security_group_ids
    content {
      description     = "PostgreSQL access"
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.merged_tags
}

resource "aws_db_parameter_group" "this" {
  count  = var.parameter_group_family == null ? 0 : 1
  name   = "${var.name}-pg"
  family = var.parameter_group_family
  tags   = local.merged_tags

  dynamic "parameter" {
    for_each = var.parameter_group_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
}

resource "aws_db_instance" "this" {
  identifier = var.name

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = var.username
  password = var.password

  multi_az          = var.multi_az
  storage_encrypted = var.storage_encrypted
  kms_key_id = var.storage_encrypted ? coalesce(var.kms_key_id, try(data.aws_kms_alias.rds[0].target_key_arn, null)) : null

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  backup_retention_period      = var.backup_retention_period
  backup_window                = var.backup_window
  maintenance_window           = var.maintenance_window
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  parameter_group_name = var.parameter_group_family == null ? null : aws_db_parameter_group.this[0].name

  skip_final_snapshot = true

  tags = local.merged_tags
}
