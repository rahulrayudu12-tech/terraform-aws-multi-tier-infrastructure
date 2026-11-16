variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zone_count" {
  type = number
}

variable "enable_nat_gateway" {
  type = bool
}
