variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "databricks_host" {
  type        = string
  description = "Databricks workspace URL (e.g. https://<workspace>.cloud.databricks.com)"
}

variable "databricks_token" {
  type        = string
  description = "Databricks PAT / OAuth token used by the databricks provider"
  sensitive   = true
}

variable "databricks_account_id" {
  type        = string
  description = "Databricks account ID, used as the external ID in the IAM role's cross-account trust policy"
}
