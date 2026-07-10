#This is the start of the main file Day3 streak
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
        Action   = ["s3:ListAllMyBuckets", "s3:ListBucket"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "nhi_runner_policy_attachment" {
  user       = aws_iam_user.nhi_automation_runner.name
  policy_arn = aws_iam_policy.policy.arn
}