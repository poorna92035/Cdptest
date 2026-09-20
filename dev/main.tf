terraform {
  required_version = ">= 1.5.0"

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

  backend "s3" {
    # Fill in with your remote state settings, e.g.:
    # bucket  = "tfstate-edp-ai-claims"
    # key     = "dev/edp-ai-claims.tfstate"
    # region  = "us-east-1"
    # encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}

provider "databricks" {
  host  = var.databricks_host
  token = var.databricks_token
}

module "edp_ai_claims" {
  source = "../modules/edp-ai-claims"

  bucket_name             = local.bucket_name
  bucket_confidentiality  = local.bucket_confidentiality
  bucket_comments         = local.bucket_comments

  policy_name = local.policy_name
  role_name   = local.role_name

  databricks_account_id     = var.databricks_account_id
  databricks_workspace_name = local.databricks_workspace_name

  storage_credential_name = local.storage_credential_name

  catalog_name        = local.catalog_name
  catalog_data_source = local.catalog_data_source

  tags = local.common_tags
}

output "bucket_arn" {
  value = module.edp_ai_claims.bucket_arn
}

output "iam_role_arn" {
  value = module.edp_ai_claims.iam_role_arn
}

output "storage_credential_name" {
  value = module.edp_ai_claims.storage_credential_name
}

output "catalog_name" {
  value = module.edp_ai_claims.catalog_name
}
