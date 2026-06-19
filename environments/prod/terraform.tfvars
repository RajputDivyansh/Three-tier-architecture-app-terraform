project_name = "terraform-2t"

aws_region = "us-east-1"

vpc_cidr = "10.100.0.0/16"

public_subnet_a_cidr = "10.100.1.0/24"
public_subnet_b_cidr = "10.100.2.0/24"

web_subnet_a_cidr = "10.100.11.0/24"
web_subnet_b_cidr = "10.100.12.0/24"

app_subnet_a_cidr = "10.100.21.0/24"
app_subnet_b_cidr = "10.100.22.0/24"

db_subnet_a_cidr = "10.100.31.0/24"
db_subnet_b_cidr = "10.100.32.0/24"

az_a = "us-east-1a"
az_b = "us-east-1b"

instance_type = "t3.micro"

key_name = "three-tier-architecture"

db_name = "demo"

db_username = "postgres"

db_password = "postgres"