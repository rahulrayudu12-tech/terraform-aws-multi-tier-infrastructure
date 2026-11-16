variable "aws_region" {
  description = "AWS region where the Terraform state bucket and lock table are created."
  type        = string
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "AWS CLI profile authenticated with IAM Identity Center."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Lowercase project identifier used in the globally unique S3 bucket name."
  type        = string
  default     = "awsintern"
}
