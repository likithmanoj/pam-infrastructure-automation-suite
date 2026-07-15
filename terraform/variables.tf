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