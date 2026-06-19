output "public_alb_dns_name" {

  value = module.alb.public_alb_dns_name
}

output "internal_alb_dns_name" {

  value = module.alb.internal_alb_dns_name
}

output "db_endpoint" {

  value = module.rds.db_endpoint
}

output "web_asg_name" {

  value = module.compute.web_asg_name
}

output "app_asg_name" {

  value = module.compute.app_asg_name
}