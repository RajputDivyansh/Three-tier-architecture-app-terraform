// PUBLIC ALB SECURITY GROUP
resource "aws_security_group" "public_alb" {

  name        = "${var.project_name}-public-alb-sg"
  description = "Public ALB Security Group"

  vpc_id = var.vpc_id

  ingress {

    description = "HTTP"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {

    description = "HTTPS"

    from_port = 443
    to_port   = 443

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-public-alb-sg"
  }
}


// WEB SECURITY GROUP
resource "aws_security_group" "web" {

  name = "${var.project_name}-web-sg"

  description = "Frontend EC2"

  vpc_id = var.vpc_id

  ingress {

    description = "HTTP From Public ALB"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    security_groups = [
      aws_security_group.public_alb.id
    ]
  }

  ingress {

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    security_groups = [
        aws_security_group.bastion.id
    ]
}

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}


// INTERNAL ALB SECURITY GROUP
resource "aws_security_group" "internal_alb" {

  name = "${var.project_name}-internal-alb-sg"

  description = "Internal ALB"

  vpc_id = var.vpc_id

  ingress {

    description = "HTTP From Web Tier"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    security_groups = [
      aws_security_group.web.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-internal-alb-sg"
  }
}


// APP SECURITY GROUP
resource "aws_security_group" "app" {

  name = "${var.project_name}-app-sg"

  description = "Backend EC2"

  vpc_id = var.vpc_id

  ingress {

    description = "Backend Traffic"

    from_port = 8080
    to_port   = 8080

    protocol = "tcp"

    security_groups = [
      aws_security_group.internal_alb.id
    ]
  }

  ingress {

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    security_groups = [
        aws_security_group.bastion.id
    ]
}

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}


// DB SECURITY GROUP
resource "aws_security_group" "db" {

  name = "${var.project_name}-db-sg"

  description = "Postgres Database"

  vpc_id = var.vpc_id

  ingress {

    description = "Postgres"

    from_port = 5432
    to_port   = 5432

    protocol = "tcp"

    security_groups = [
      aws_security_group.app.id
    ]
  }

  ingress {

    from_port = 5432
    to_port   = 5432

    protocol = "tcp"

    security_groups = [
        aws_security_group.bastion.id
    ]
  }

  tags = {
    Name = "${var.project_name}-db-sg"
  }
}


// BASTION SECURITY GROUP
resource "aws_security_group" "bastion" {

  name        = "${var.project_name}-bastion-sg"
  description = "Bastion Security Group"
  vpc_id      = var.vpc_id

  ingress {

    description = "SSH"

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    cidr_blocks = [
      var.admin_ip
    ]
  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}