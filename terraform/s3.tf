resource "aws_s3_bucket" "nhi_automation_bucket" {

  bucket        = "${var.project_name}-${var.environment}-bucket"
  force_destroy = true
  tags = {
    Name        = "${var.project_name}-${var.environment}-bucket"
    Environment = var.environment
  }

}


#Added this below block to add Server side encryption - because on the disk and at rest the data needs to be encrypted, but for prod purposes we can use AWS KMS, for now we are just utilizing the AES256 algorithm instead of KMS
#Why because of the data at rest is supposed to be encrypted - and Data at movement is projected by HTTPS and other networking components.

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_for_s3_bucket" {
  bucket = aws_s3_bucket.nhi_automation_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

resource "aws_s3_bucket_public_access_block" "nhi_automation_bucket_privacy" {
  bucket = aws_s3_bucket.nhi_automation_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
