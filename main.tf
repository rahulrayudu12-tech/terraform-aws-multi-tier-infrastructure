locals {
  app_log_group_name = "/aws/${var.project_name}/${var.environment}/application"
}

resource "aws_cloudwatch_log_group" "application" {
  name              = local.app_log_group_name
  retention_in_days = var.log_retention_days
}

module "vpc" {
  source = "./modules/vpc"

  project_name            = var.project_name
  environment             = var.environment
  vpc_cidr                = var.vpc_cidr
  availability_zone_count = var.availability_zone_count
  enable_nat_gateway      = var.enable_nat_gateway
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  enable_https = var.enable_https
}

module "alb" {
  source = "./modules/alb"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  enable_https          = var.enable_https
  domain_name           = var.domain_name
  route53_zone_id       = var.route53_zone_id
}

module "ec2" {
  source = "./modules/ec2"

  project_name          = var.project_name
  environment           = var.environment
  instance_type         = var.instance_type
  min_size              = var.asg_min_size
  desired_capacity      = var.asg_desired_capacity
  max_size              = var.asg_max_size
  app_subnet_ids        = module.vpc.app_subnet_ids
  app_security_group_id = module.security.app_security_group_id
  target_group_arn      = module.alb.target_group_arn
  app_log_group_name    = local.app_log_group_name

  depends_on = [aws_cloudwatch_log_group.application]
}

module "rds" {
  source = "./modules/rds"

  project_name          = var.project_name
  environment           = var.environment
  db_name               = var.db_name
  db_username           = var.db_username
  db_instance_class     = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  backup_retention_days = var.db_backup_retention_days
  db_subnet_ids         = module.vpc.database_subnet_ids
  db_security_group_id  = module.security.database_security_group_id
}

module "monitoring" {
  source = "./modules/monitoring"

  project_name           = var.project_name
  environment            = var.environment
  autoscaling_group_name = module.ec2.autoscaling_group_name
  load_balancer_suffix   = module.alb.load_balancer_suffix
  target_group_suffix    = module.alb.target_group_suffix
}
