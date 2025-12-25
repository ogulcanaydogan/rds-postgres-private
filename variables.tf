variable "name" {
  type        = string
  description = "Name prefix for the RDS resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the RDS security group."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the DB subnet group."
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "Security group IDs allowed to connect to the database."
  default     = []
}

variable "engine_version" {
  type        = string
  description = "PostgreSQL engine version."
  default     = "16.3"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class."
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage in GB."
  default     = 20
}

variable "db_name" {
  type        = string
  description = "Database name to create."
}

variable "username" {
  type        = string
  description = "Master username."
}

variable "password" {
  type        = string
  description = "Master password."
  sensitive   = true
}

variable "multi_az" {
  type        = bool
  description = "Whether to enable Multi-AZ deployment."
  default     = false
}

variable "storage_encrypted" {
  type        = bool
  description = "Whether to enable storage encryption."
  default     = true
}

variable "backup_retention_period" {
  type        = number
  description = "Number of days to retain backups."
  default     = 7
}

variable "backup_window" {
  type        = string
  description = "Preferred backup window in UTC (e.g., 03:00-04:00)."
  default     = null
}

variable "maintenance_window" {
  type        = string
  description = "Preferred maintenance window in UTC (e.g., Sun:05:00-Sun:06:00)."
  default     = null
}

variable "parameter_group_family" {
  type        = string
  description = "Parameter group family (e.g., postgres16). When null, use the default parameter group."
  default     = null
}

variable "parameter_group_parameters" {
  type = list(object({
    name         = string
    value        = string
    apply_method = string
  }))
  description = "Parameters for the optional parameter group."
  default     = []
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "CloudWatch log exports to enable."
  default     = []
}

variable "kms_key_id" {
  type        = string
  description = "Optional KMS key ARN/ID for storage encryption. Defaults to aws/rds when storage_encrypted is true."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}
