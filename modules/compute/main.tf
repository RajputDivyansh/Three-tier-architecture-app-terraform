// AMI Data Source for Ubuntu 26.04
data "aws_ami" "ubuntu" {

  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


// Launch Template for Web Tier
resource "aws_launch_template" "web" {

  name_prefix = "${var.project_name}-web-"

  image_id = data.aws_ami.ubuntu.id

  instance_type = var.instance_type

  key_name = var.key_name

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [
    var.web_sg_id
  ]

  user_data = base64encode(
    file("${path.root}/../../userdata/web.sh")
  )

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-web"
    }
  }
}


// Launch Template for App Tier
resource "aws_launch_template" "app" {

  name_prefix = "${var.project_name}-app-"

  image_id = data.aws_ami.ubuntu.id

  instance_type = var.instance_type

  key_name = var.key_name

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [
    var.app_sg_id
  ]

  user_data = base64encode(
    file("${path.root}/../../userdata/app.sh")
  )

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-app"
    }
  }
}


// Auto Scaling Group for Web Tier
resource "aws_autoscaling_group" "web" {

  name = "${var.project_name}-web-asg"

  desired_capacity = 2

  min_size = 2

  max_size = 4

  vpc_zone_identifier = var.web_subnet_ids

  target_group_arns = [
    var.web_target_group_arn
  ]

  launch_template {

    id = aws_launch_template.web.id

    version = "$Latest"
  }

  health_check_type = "ELB"

  health_check_grace_period = 300

  tag {

    key = "Name"

    value = "${var.project_name}-web"

    propagate_at_launch = true
  }
}


// Auto Scaling Group for App Tier
resource "aws_autoscaling_group" "app" {

  name = "${var.project_name}-app-asg"

  desired_capacity = 2

  min_size = 2

  max_size = 4

  vpc_zone_identifier = var.app_subnet_ids

  target_group_arns = [
    var.app_target_group_arn
  ]

  launch_template {

    id = aws_launch_template.app.id

    version = "$Latest"
  }

  health_check_type = "ELB"

  health_check_grace_period = 300

  tag {

    key = "Name"

    value = "${var.project_name}-app"

    propagate_at_launch = true
  }
}