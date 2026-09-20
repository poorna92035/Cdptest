terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.50"
    }
  }
}

data "aws_caller_identity" "current" {}

# ---------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------
output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.this.bucket
}

output "iam_policy_arn" {
  description = "ARN of the RWD access IAM policy"
  value       = aws_iam_policy.rwd_access.arn
}

output "iam_role_arn" {
  description = "ARN of the Databricks external-access IAM role"
  value       = aws_iam_role.databricks_role.arn
}

output "iam_role_name" {
  description = "Name of the Databricks external-access IAM role"
  value       = aws_iam_role.databricks_role.name
}

output "instance_profile_arn" {
  description = "ARN of the EC2 instance profile wrapping the role"
  value       = aws_iam_instance_profile.this.arn
}

output "storage_credential_name" {
  description = "Name of the Databricks storage credential"
  value       = databricks_storage_credential.this.name
}

output "catalog_name" {
  description = "Name of the Databricks catalog"
  value       = databricks_catalog.this.name
}
