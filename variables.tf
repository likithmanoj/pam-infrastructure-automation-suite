variable "environment" {
  type    = string
  description = "The environment for the PAM automation suite"
  default     = "dev"
}

variable "project_name" {
  type    = string
  description = "The name of the project"
  default     = "pam-infrastructure-automation-suite"
}