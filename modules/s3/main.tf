resource "aws_s3_bucket" "app_storage" {
  bucket        = "${var.project_name}-${var.environment}-assets-${var.bucket_suffix}"
  force_destroy = var.force_destroy

  tags = merge(var.tags, { Name = "${var.project_name}-s3-bucket" })
}

# Enable Server-Side Encryption (AES256)
resource "aws_s3_bucket_server_side_encryption_configuration" "app_storage" {
  bucket = aws_s3_bucket.app_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block Public Access Configuration
resource "aws_s3_bucket_public_access_block" "app_storage" {
  bucket                  = aws_s3_bucket.app_storage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}