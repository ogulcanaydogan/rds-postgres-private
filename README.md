# rds-postgres-private

Terraform module that provisions a private Amazon RDS PostgreSQL instance with a subnet group, security group, optional parameter group, and optional CloudWatch log exports.

## Usage

```hcl
module "rds_postgres_private" {
  source = "./rds-postgres-private"

  name                  = "example-postgres"
  vpc_id                = "vpc-123456"
  private_subnet_ids    = ["subnet-aaa", "subnet-bbb"]
  allowed_security_group_ids = ["sg-123456"]

  db_name  = "app"
  username = "appuser"
  password = "super-secret"

  tags = {
    Environment = "dev"
  }
}
```

## Requirements

- Terraform >= 1.5
- AWS provider >= 5.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name prefix for the RDS resources. | `string` | n/a | yes |
| vpc_id | VPC ID for the RDS security group. | `string` | n/a | yes |
| private_subnet_ids | List of private subnet IDs for the DB subnet group. | `list(string)` | n/a | yes |
| allowed_security_group_ids | Security group IDs allowed to connect to the database. | `list(string)` | `[]` | no |
| engine_version | PostgreSQL engine version. | `string` | `"16.3"` | no |
| instance_class | RDS instance class. | `string` | `"db.t4g.micro"` | no |
| allocated_storage | Allocated storage in GB. | `number` | `20` | no |
| db_name | Database name to create. | `string` | n/a | yes |
| username | Master username. | `string` | n/a | yes |
| password | Master password. | `string` | n/a | yes |
| multi_az | Whether to enable Multi-AZ deployment. | `bool` | `false` | no |
| storage_encrypted | Whether to enable storage encryption. | `bool` | `true` | no |
| backup_retention_period | Number of days to retain backups. | `number` | `7` | no |
| backup_window | Preferred backup window in UTC (e.g., 03:00-04:00). | `string` | `null` | no |
| maintenance_window | Preferred maintenance window in UTC (e.g., Sun:05:00-Sun:06:00). | `string` | `null` | no |
| parameter_group_family | Parameter group family (e.g., postgres16). When null, use the default parameter group. | `string` | `null` | no |
| parameter_group_parameters | Parameters for the optional parameter group. | `list(object({name=string,value=string,apply_method=string}))` | `[]` | no |
| enabled_cloudwatch_logs_exports | CloudWatch log exports to enable. | `list(string)` | `[]` | no |
| kms_key_id | Optional KMS key ARN/ID for storage encryption. Defaults to aws/rds when storage_encrypted is true. | `string` | `null` | no |
| tags | Tags to apply to resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| db_instance_identifier | RDS instance identifier. |
| endpoint | RDS instance endpoint. |
| port | RDS instance port. |
| security_group_id | Security group ID for the RDS instance. |
| subnet_group_name | DB subnet group name. |

## Examples

See [examples/minimal](examples/minimal) for a minimal configuration.
