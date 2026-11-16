data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  bucket_name = lower("${var.project_name}-${var.environment}-storage-${data.aws_caller_identity.current.account_id}")

  create_bucket_cmd = (
    data.aws_region.current.name == "us-east-1"
    ? "aws s3api create-bucket --bucket ${local.bucket_name} --region ${data.aws_region.current.name}"
    : "aws s3api create-bucket --bucket ${local.bucket_name} --region ${data.aws_region.current.name} --create-bucket-configuration LocationConstraint=${data.aws_region.current.name}"
  )
}

resource "aws_s3_bucket" "this" {
  count         = var.use_cli_bucket_creation ? 0 : 1
  bucket        = local.bucket_name
  force_destroy = true

  tags = {
    Name = local.bucket_name
  }
}

resource "terraform_data" "bucket" {
  count = var.use_cli_bucket_creation ? 1 : 0

  input = {
    bucket_name = local.bucket_name
    create_cmd  = local.create_bucket_cmd
  }

  provisioner "local-exec" {
    when    = create
    command = self.input.create_cmd
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rb s3://${self.input.bucket_name} --force"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = local.bucket_name

  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [aws_s3_bucket.this, terraform_data.bucket]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = local.bucket_name

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

  depends_on = [aws_s3_bucket.this, terraform_data.bucket]
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = local.bucket_name

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket.this, terraform_data.bucket]
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = local.bucket_name

  rule {
    id     = "archive-and-expire-noncurrent"
    status = "Enabled"

    filter {}

    transition {
      days          = var.transition_ia_days
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_expiration_days
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}