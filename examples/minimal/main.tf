terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "rds_postgres_private" {
  source = "../.."

  name                     = "example-postgres"
  vpc_id                   = "vpc-123456"
  private_subnet_ids       = ["subnet-aaa", "subnet-bbb"]
  allowed_security_group_ids = ["sg-123456"]

  db_name  = "app"
  username = "appuser"
  password = "super-secret"

  tags = {
    Environment = "dev"
  }
}
