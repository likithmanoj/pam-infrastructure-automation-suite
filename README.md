```markdown
# PAM Infrastructure Automation Suite

This repository contains the foundational Terraform configurations to provision a secure, automated environment for privilege management operations.

## 📝 Project Architecture Notes

### 1. Variables & Custom Input Validation (`variables.tf`)
The deployment configuration uses input variables to prevent hardcoded environments. The deployment scope is restricted via a custom validation block to ensure execution only occurs inside approved stages.

```hcl
variable "environment" {
  type        = string
  description = "The environment for the PAM automation suite"
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "The environment value must be one of: dev, test, prod."
  }
}

variable "project_name" {
  type        = string
  description = "The name of the project"
  default     = "pam-infrastructure-automation-suite"
}

```

* **Validation Guardrail:** The `validation` statement ensures that the engine only accepts `dev`, `test`, or `prod` as accepted environment strings.

---

### 2. Identity & Credentials (`main.tf`)

We provision a dedicated, non-human IAM automation runner identity placed under a `/system/` path boundary, alongside its API access keys for programmatic execution.

```hcl
resource "aws_iam_user" "nhi_automation_runner" {
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

```

---

### 3. Dynamic Partitions & Least-Privilege IAM Policy (`main.tf`)

To ensure optimal security posture, we avoid global wildcard resources (`*`) and implement a strict **Least-Privilege Blast Radius**.

```hcl
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
        Action = ["s3:ListAllMyBuckets", "s3:ListBucket", "s3:GetObject", "s3:PutObject"]
        Effect = "Allow"
        Resource = [
          "arn:${data.aws_partition.current.partition}:s3:::${var.project_name}-${var.environment}-bucket",
          "arn:${data.aws_partition.current.partition}:s3:::${var.project_name}-${var.environment}-bucket/*"
        ]
      }
    ]
  })
}

```

* **Dynamic Partitioning:** The `data "aws_partition" "current" {}` block fetches the active AWS partition dynamically at runtime. This data is passed into the IAM Policy resource to form precise ARNs instead of hardcoding standard partition paths.
* **Targeted Operations:** The actions `s3:GetObject` and `s3:PutObject` are explicitly declared to grant the downstream Python engine permission to read and edit required data payloads inside the bucket boundary.

---

### 4. Identity Policy Binding (`main.tf`)

The policy attachment resource explicitly links our custom least-privilege policy to the automation runner user identity.

```hcl
resource "aws_iam_user_policy_attachment" "nhi_runner_policy_attachment" {
  user       = aws_iam_user.nhi_automation_runner.name
  policy_arn = aws_iam_policy.policy.arn
}

```

---

### 5. Deployment Outputs (`outputs.tf`)

Outputs expose the critical identifiers needed by external scripts to leverage this infrastructure layer safely.

```hcl
output "nhi_automation_runner_arn" {
  value       = aws_iam_user.nhi_automation_runner.arn
  description = "The Amazon Resource Name (ARN) of the NHI Automation Runner IAM user"
}

output "nhi_automation_runner_access_key_id" {
  value       = aws_iam_access_key.nhi_runner_keys.id
  description = "The access key ID for the NHI Automation Runner IAM user"
}

```

```

```