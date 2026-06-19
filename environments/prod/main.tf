// Main Terraform configuration for the production environment
// Networking Module
module "networking" {

  source = "../../modules/networking"

  project_name = var.project_name

  vpc_cidr = var.vpc_cidr

  public_subnet_a_cidr = var.public_subnet_a_cidr
  public_subnet_b_cidr = var.public_subnet_b_cidr

  web_subnet_a_cidr = var.web_subnet_a_cidr
  web_subnet_b_cidr = var.web_subnet_b_cidr

  app_subnet_a_cidr = var.app_subnet_a_cidr
  app_subnet_b_cidr = var.app_subnet_b_cidr

  db_subnet_a_cidr = var.db_subnet_a_cidr
  db_subnet_b_cidr = var.db_subnet_b_cidr

  az_a = var.az_a
  az_b = var.az_b
}


// Security Module
module "security" {

  source = "../../modules/security"

  project_name = var.project_name

  vpc_id = module.networking.vpc_id
}


// IAM Module
module "iam" {

  source = "../../modules/iam"

  project_name = var.project_name
}


// ALB Module
module "alb" {

  source = "../../modules/alb"

  project_name = var.project_name

  vpc_id = module.networking.vpc_id

  public_subnet_ids = module.networking.public_subnet_ids

  app_subnet_ids = module.networking.app_subnet_ids

  public_alb_sg_id = module.security.public_alb_sg_id

  internal_alb_sg_id = module.security.internal_alb_sg_id
}


// Compute Module
module "compute" {

  source = "../../modules/compute"

  project_name = var.project_name

  web_subnet_ids = module.networking.web_subnet_ids

  app_subnet_ids = module.networking.app_subnet_ids

  web_sg_id = module.security.web_sg_id

  app_sg_id = module.security.app_sg_id

  web_target_group_arn = module.alb.web_target_group_arn

  app_target_group_arn = module.alb.app_target_group_arn

  instance_profile_name = module.iam.instance_profile_name

  instance_type = var.instance_type

  key_name = var.key_name
}


// RDS Module
module "rds" {

  source = "../../modules/rds"

  project_name = var.project_name

  db_subnet_ids = module.networking.db_subnet_ids

  db_sg_id = module.security.db_sg_id

  db_name = var.db_name

  db_username = var.db_username

  db_password = var.db_password
}