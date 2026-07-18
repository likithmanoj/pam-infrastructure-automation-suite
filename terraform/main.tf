#Creating the IAM user using variable placeholder
resource "aws_iam_user" "nhi_automation_runner" {

  /*
  SECURITY AUDIT LEDGER
  Owner: Identity Security Automation Team
  Purpose: Non-Human Identity Runner for Secrets Migration Engine
  Compliance: SOP-IAM-01 / Least Privilege Baseline
  */

  name          = "nhi-automation-runner-${var.environment}"
  path          = "/system/"
  force_destroy = true

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_access_key" "nhi_runner_keys" {
  user = aws_iam_user.nhi_automation_runner.name
}

data "aws_partition" "current" {}

resource "aws_iam_policy" "policy" {
  name        = "${var.project_name}-${var.environment}-s3-policy"
  path        = "/"
  description = "IAM policy for automation runner to access S3 buckets in ${var.environment} environment"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Allow the automation runner to perform S3 actions on the specified bucket when Python is run we need GetObject and PutObject permissions to read and write files to the S3 bucket
        Action = ["s3:ListBucket", "s3:GetObject", "s3:PutObject"]
        Effect = "Allow"
        Resource = [
          "arn:${data.aws_partition.current.partition}:s3:::${var.project_name}-${var.environment}-bucket",
          "arn:${data.aws_partition.current.partition}:s3:::${var.project_name}-${var.environment}-bucket/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "nhi_runner_policy_attachment" {
  user       = aws_iam_user.nhi_automation_runner.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_s3_bucket" "nhi_automation_bucket" {

  bucket        = "${var.project_name}-${var.environment}-bucket"
  force_destroy = true
  tags = {
    Name        = "${var.project_name}-${var.environment}-bucket"
    Environment = var.environment
  }

}

resource "aws_s3_bucket_public_access_block" "nhi_automation_bucket_privacy" {
  bucket = aws_s3_bucket.nhi_automation_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_caller_identity" "current_user" {}

resource "aws_iam_role" "nhi_automation_runner_role" {
  name = "nhi-automation-runner-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current_user.account_id}:user/${aws_iam_user.nhi_automation_runner.name}"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "nhi_automation_runner_role_policy_attachment" {
  role       = aws_iam_role.nhi_automation_runner_role.name
  policy_arn = aws_iam_policy.policy.arn
}