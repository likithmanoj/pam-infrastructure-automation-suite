#This is the start of the main file Day2 streak
resource "aws_iam_user" "nhi_automation_runner" {

  /*
  SECURITY AUDIT LEDGER
  Owner: Identity Security Automation Team
  Purpose: Non-Human Identity Runner for Secrets Migration Engine
  Compliance: SOP-IAM-01 / Least Privilege Baseline
  */

  name = "nhi-automation-runner"
  path = "/system/"

  tags = {
    Environment = "Development"
  }
}

resource "aws_iam_access_key" "nhi_runner_keys" {
  user = aws_iam_user.nhi_automation_runner.name
}