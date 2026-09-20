locals {
  # --- Bucket -------------------------------------------------------------
  bucket_name            = "rnd-pr-ab-claims-dbx-edp-ai"
  bucket_confidentiality = "C4"
  bucket_comments        = "only access processes"

  # --- IAM ------------------------------------------------------------------
  policy_name = "access_edp_s3_rwd_ab_claims_wrk_rnd_prod"
  role_name   = "_edp_ai_databricks_dl_ab_claims_rnd_prod"

  # --- Databricks workspace -------------------------------------------------
  databricks_workspace_name = "edp-ai-claims-rnd-prod"

  # --- Storage credential ----------------------------------------------------
  storage_credential_name = "cred_ab_claims_rnd_edp_ai_prod"

  # --- Catalog ---------------------------------------------------------------
  catalog_name        = "cat_rnd_ab_claims_edp_ai"
  catalog_data_source = "s3://${local.bucket_name}/"

  common_tags = {
    Environment = var.environment
    Domain      = "edp-ai-claims"
    ManagedBy   = "terraform"
  }
}
