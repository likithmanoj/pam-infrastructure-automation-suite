output "nhi_automation_runner_arn" {
  value       = aws_iam_user.nhi_automation_runner.arn
  description = "The Amazon Resource Name (ARN) of the NHI Automation Runner IAM user"
}
output "nhi_automation_runner_access_key_id" {
  value       = aws_iam_access_key.nhi_runner_keys.id
  description = "The access key ID for the NHI Automation Runner IAM user"
}