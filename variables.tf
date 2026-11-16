
variable "aws_region" {
  description = "AWS region used for this deployment."
  type        = string
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "AWS CLI profile authenticated with IAM Identity Center."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Lowercase project identifier used in resource names."
  type        = string
  default     = "awsintern"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,20}$", var.project_name))
    error_message = "project_name must start with a lowercase letter and contain only lowercase letters, digits, or hyphens."
  }
}

variable "environment" {
  description = "Environment name; use the same value in the matching tfvars file."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging, or prod."
  }
}

variable "vpc_cidr" {
  description = "IPv4 CIDR range for the VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zone_count" {
  description = "Number of Availability Zones; two are used for subnet redundancy."
  type        = number
  default     = 2

  validation {
    condition     = var.availability_zone_count >= 2 && var.availability_zone_count <= 3
    error_message = "availability_zone_count must be 2 or 3."
  }
}

variable "enable_nat_gateway" {
  description = "Create one shared NAT Gateway for private application subnet egress; this incurs hourly and data-processing charges."
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "EC2 instance type used by the Auto Scaling Group."
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "Minimum number of application instances."
  type        = number
  default     = 1
}

variable "asg_desired_capacity" {
  description = "Initial desired number of application instances."
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of application instances."
  type        = number
  default     = 2
}

variable "db_name" {
  description = "Initial MySQL database name."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "RDS master username; the password is managed by AWS Secrets Manager."
  type        = string
  default     = "appadmin"
}

variable "db_instance_class" {
  description = "RDS instance class. AWS charges apply and free-tier eligibility varies."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Initial encrypted RDS storage in GiB."
  type        = number
  default     = 20
}

variable "db_backup_retention_days" {
  description = "Automated RDS backup retention in days."
  type        = number
  default     = 1
}

variable "log_retention_days" {
  description = "CloudWatch application log retention in days."
  type        = number
  default     = 7
}

variable "enable_https" {
  description = "Request a DNS-validated ACM certificate and enable HTTPS; requires a Route 53 hosted zone."
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Fully qualified domain name in the supplied Route 53 hosted zone; required when HTTPS is enabled."
  type        = string
  default     = ""
}

variable "route53_zone_id" {
  description = "Existing public Route 53 hosted zone ID; required when HTTPS is enabled."
  type        = string
  default     = ""
}