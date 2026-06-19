// Application Load Balancer (ALB) for public access
resource "aws_lb" "public" {

  name = "${var.project_name}-public-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    var.public_alb_sg_id
  ]

  subnets = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-public-alb"
  }
}


// Application Load Balancer (ALB) for internal access
resource "aws_lb" "internal" {

  name = "${var.project_name}-internal-alb"

  internal = true

  load_balancer_type = "application"

  security_groups = [
    var.internal_alb_sg_id
  ]

  subnets = var.app_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-internal-alb"
  }
}


// Target Group for Web Tier
resource "aws_lb_target_group" "web" {

  name = "${var.project_name}-web-tg"

  port = 80

  protocol = "HTTP"

  target_type = "instance"

  vpc_id = var.vpc_id

  health_check {

    enabled = true

    path = "/"

    protocol = "HTTP"

    matcher = "200"

    interval = 10

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project_name}-web-tg"
  }
}


// Target Group for App Tier
resource "aws_lb_target_group" "app" {

  name = "${var.project_name}-app-tg"

  port = 8080

  protocol = "HTTP"

  target_type = "instance"

  vpc_id = var.vpc_id

  health_check {

    enabled = true

    path = "/actuator/health"

    protocol = "HTTP"

    matcher = "200"

    interval = 10

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project_name}-app-tg"
  }
}


// Listener for Public ALB
resource "aws_lb_listener" "public_http" {

  load_balancer_arn = aws_lb.public.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.web.arn
  }
}


// Listener for Internal ALB
# resource "aws_lb_listener" "public_https" {
#
# }



resource "aws_lb_listener" "internal_http" {

  load_balancer_arn = aws_lb.internal.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.app.arn
  }
}


// THESE BELOW ARE OPTIONAL RESOURCES FOR ROUTE 53 INTEGRATION WHICH WILL MAKE DNS 
//RESOLUTION POSSIBLE FOR INTERNAL SERVICES AND NO NEED TO CHANGE INTERNAL ALB DOMAIN 
// EVERYTIME WE RUN THIS SCRIPT.
// THERE ARE TWO WAYS TO MAKE THIS NGINX SERVICE ACCESSIBLE INTERNALLY. 
// 1. CREATE A PRIVATE ROUTE 53 HOSTED ZONE AND CREATE A RECORD FOR INTERNAL ALB BEFORE HAND AND HARD CODE IN NGINX FILE.
// 2. PASS IT AS VARIABLE IN USER_DATA TEMPLATE FILE
// UNCOMMENT IF YOU WANT TO USE THEM.

// Private Route 53 Hosted Zone for internal services
# resource "aws_route53_zone" "private_zone" {
#   name = "ttr.personal"

#   vpc {
#     vpc_id = aws_vpc.main.id
#   }

#   comment = "Private hosted zone for internal services"
# }


// Route 53 Record for Internal ALB ALIAS
# resource "aws_route53_record" "backend" {
#   zone_id = aws_route53_zone.private_zone.zone_id
#   name    = "backend"
#   type    = "A"

#   alias {
#     name                   = aws_lb.internal.dns_name
#     zone_id                = aws_lb.internal.zone_id
#     evaluate_target_health = true
#   }
# }