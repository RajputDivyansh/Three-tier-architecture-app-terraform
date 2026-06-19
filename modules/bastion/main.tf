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


// Bastion Host Instance
resource "aws_instance" "bastion" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = var.public_subnet_id

  key_name = var.key_name

  vpc_security_group_ids = [
    var.bastion_sg_id
  ]

  associate_public_ip_address = true

  user_data = file("${path.root}/../../userdata/bastion.sh")

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "${var.project_name}-bastion"
  }
}