output "target_group_arn" {
  value = aws_lb_target_group.application.arn
}

output "target_group_suffix" {
  value = aws_lb_target_group.application.arn_suffix
}

output "load_balancer_suffix" {
  value = aws_lb.application.arn_suffix
}

output "dns_name" {
  value = aws_lb.application.dns_name
}

output "application_url" {
  value = var.enable_https ? "https://${var.domain_name}" : "http://${aws_lb.application.dns_name}"
}
