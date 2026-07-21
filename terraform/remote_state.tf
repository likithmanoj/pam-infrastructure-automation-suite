resource "aws_s3_bucket" "remote_state_bucket" {

  bucket = "pam-infrastructure-automation-suite-tfstate" #hardcoded because we only have static buckets and once created it stays that way
  tags = {
    Name        = "pam-infrastructure-automation-suite-tfstate"
    Environment = var.environment
  }

}

resource "aws_s3_bucket_versioning" "remote_state_bucket_versioning" {
  bucket = aws_s3_bucket.remote_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_for_remote_state_bucket" {
  bucket = aws_s3_bucket.remote_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "remote_state_bucket_privacy" {
  bucket = aws_s3_bucket.remote_state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}