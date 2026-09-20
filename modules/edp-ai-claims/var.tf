variable "bucket_name" {
  type        = string
  description = "S3 bucket name (without the s3:// prefix), e.g. rnd-pr-ab-claims-dbx-edp-ai"
}

variable "bucket_confidentiality" {
  type        = string
  description = "Confidentiality classification tag applied to the bucket (e.g. C4)"
  default     = "C4"
}

variable "bucket_comments" {
  type        = string
  description = "Free-text comment tag describing bucket usage/access restrictions"
  default     = "only access processes"
}

variable "policy_name" {
  type        = string
  description = "Name of the IAM policy granting Read/Write/Delete access to the bucket"
}

variable "role_name" {
  type        = string
  description = "Name of the IAM role assumed via EC2 instance profile, used for Databricks external access"
}

variable "databricks_account_id" {
  type        = string
  description = "Databricks account ID used as the external ID condition in the cross-account trust policy"
}

variable "databricks_workspace_name" {
  type        = string
  description = "Name of the Databricks workspace this role/credential is associated with (documentation/tagging only; workspace itself is assumed pre-provisioned)"
}

variable "storage_credential_name" {
  type        = string
  description = "Name of the Databricks Unity Catalog storage credential"
}

variable "catalog_name" {
  type        = string
  description = "Name of the Databricks Unity Catalog catalog"
}

variable "catalog_data_source" {
  type        = string
  description = "S3 URI used as the storage root / data source for the catalog"
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to all taggable resources"
  default     = {}
}
