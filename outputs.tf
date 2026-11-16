output "vpc_id" {
  description = "ID of the project VPC."
  value       = module.vpc.vpc_id
}

output "application_url" {
  description = "HTTP application URL, or HTTPS when a domain is configured."
  value       = module.alb.application_url
}

output "load_balancer_dns_name" {
  description = "DNS name assigned to the Application Load Balancer."
  value       = module.alb.dns_name
}

output "autoscaling_group_name" {
  description = "Name of the application Auto Scaling Group."
  value       = module.ec2.autoscaling_group_name
}

output "database_endpoint" {
  description = "Private MySQL endpoint; credentials are managed separately by AWS Secrets Manager."
  value       = module.rds.endpoint
}

output "application_log_group" {
  description = "CloudWatch log group receiving application host logs."
  value       = aws_cloudwatch_log_group.application.name
}
