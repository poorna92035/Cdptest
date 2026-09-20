# ---------------------------------------------------------------------------
# S3 bucket
# ---------------------------------------------------------------------------
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = merge(var.tags, {
    Confidentiality = var.bucket_confidentiality
    Comments        = var.bucket_comments
  })
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ---------------------------------------------------------------------------
# IAM policy - RWD (Read/Write/Delete) access, scoped to this bucket only
# ---------------------------------------------------------------------------
resource "aws_iam_policy" "rwd_access" {
  name        = var.policy_name
  description = "Read/Write/Delete access to s3://${var.bucket_name}/*"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListBucket"
        Effect = "Allow"
        Action = ["s3:ListBucket"]
        Resource = [aws_s3_bucket.this.arn]
      },
      {
        Sid    = "ReadWriteDeleteObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = ["${aws_s3_bucket.this.arn}/*"]
      }
    ]
  })

  tags = var.tags
}

# ---------------------------------------------------------------------------
# IAM role - EC2 trust relationship, external access type: Databricks
# ---------------------------------------------------------------------------
resource "aws_iam_role" "databricks_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EC2TrustRelationship"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      {
        # Standard Databricks Unity Catalog cross-account assume-role trust,
        # scoped with the workspace/account external ID.
        Sid    = "DatabricksExternalAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::414351767826:role/unity-catalog-prod-UCMasterRole-14S5ZJVKOTYTL"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.databricks_account_id
          }
        }
      }
    ]
  })

  tags = merge(var.tags, {
    DatabricksWorkspace = var.databricks_workspace_name
  })
}

resource "aws_iam_role_policy_attachment" "attach_rwd" {
  role       = aws_iam_role.databricks_role.name
  policy_arn = aws_iam_policy.rwd_access.arn
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.role_name}-instance-profile"
  role = aws_iam_role.databricks_role.name
}

# ---------------------------------------------------------------------------
# Databricks storage credential (Unity Catalog)
# NOTE: assumes the target Databricks workspace / metastore already exists
# and the databricks provider is configured to point at it (see dev/main.tf).
# ---------------------------------------------------------------------------
resource "databricks_storage_credential" "this" {
  name = var.storage_credential_name

  aws_iam_role {
    role_arn = aws_iam_role.databricks_role.arn
  }

  comment = "RWD storage credential for s3://${var.bucket_name}, workspace ${var.databricks_workspace_name}"

  depends_on = [aws_iam_role_policy_attachment.attach_rwd]
}

# ---------------------------------------------------------------------------
# Databricks catalog
# ---------------------------------------------------------------------------
resource "databricks_catalog" "this" {
  name         = var.catalog_name
  storage_root = var.catalog_data_source
  comment      = "Catalog backed by ${var.catalog_data_source}"

  depends_on = [databricks_storage_credential.this]
}
