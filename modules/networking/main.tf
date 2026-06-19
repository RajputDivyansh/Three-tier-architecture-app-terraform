// VPC
resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  enable_dns_support = true

  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}


// INTERNET GATEWAY
resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}


// PUBLIC SUBNETS
resource "aws_subnet" "public_a" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_a_cidr

  availability_zone = var.az_a

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-a"
  }
}

resource "aws_subnet" "public_b" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_b_cidr

  availability_zone = var.az_b

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-b"
  }
}


// WEB SUBNETS
resource "aws_subnet" "web_a" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.web_subnet_a_cidr

  availability_zone = var.az_a

  tags = {
    Name = "${var.project_name}-web-a"
  }
}

resource "aws_subnet" "web_b" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.web_subnet_b_cidr

  availability_zone = var.az_b

  tags = {
    Name = "${var.project_name}-web-b"
  }
}


// APP SUBNETS
resource "aws_subnet" "app_a" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.app_subnet_a_cidr

  availability_zone = var.az_a

  tags = {
    Name = "${var.project_name}-app-a"
  }
}

resource "aws_subnet" "app_b" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.app_subnet_b_cidr

  availability_zone = var.az_b

  tags = {
    Name = "${var.project_name}-app-b"
  }
}


// DB SUBNETS
resource "aws_subnet" "db_a" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.db_subnet_a_cidr

  availability_zone = var.az_a

  tags = {
    Name = "${var.project_name}-db-a"
  }
}

resource "aws_subnet" "db_b" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.db_subnet_b_cidr

  availability_zone = var.az_b

  tags = {
    Name = "${var.project_name}-db-b"
  }
}


// ELASTIC IPs FOR NAT GATEWAYS
resource "aws_eip" "nat_a" {

  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-a-eip"
  }
}

resource "aws_eip" "nat_b" {

  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-b-eip"
  }
}


// NAT GATEWAYS
resource "aws_nat_gateway" "nat_a" {

  allocation_id = aws_eip.nat_a.id

  subnet_id = aws_subnet.public_a.id

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = {
    Name = "${var.project_name}-nat-a"
  }
}

resource "aws_nat_gateway" "nat_b" {

  allocation_id = aws_eip.nat_b.id

  subnet_id = aws_subnet.public_b.id

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = {
    Name = "${var.project_name}-nat-b"
  }
}


// PUBLIC ROUTE TABLES
resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}


// PRIVATE ROUTE TABLE A
resource "aws_route_table" "private_a" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat_a.id
  }

  tags = {
    Name = "${var.project_name}-private-a-rt"
  }
}


// PRIVATE ROUTE TABLE B
resource "aws_route_table" "private_b" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat_b.id
  }

  tags = {
    Name = "${var.project_name}-private-b-rt"
  }
}


// PUBLIC ROUTE TABLE ASSOCIATIONS
resource "aws_route_table_association" "public_a" {

  subnet_id = aws_subnet.public_a.id

  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {

  subnet_id = aws_subnet.public_b.id

  route_table_id = aws_route_table.public.id
}


// PRIVATE ROUTE TABLE ASSOCIATIONS FOR SUBNETS IN AVAILABILITY ZONE A
resource "aws_route_table_association" "web_a" {

  subnet_id = aws_subnet.web_a.id

  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "app_a" {

  subnet_id = aws_subnet.app_a.id

  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "db_a" {

  subnet_id = aws_subnet.db_a.id

  route_table_id = aws_route_table.private_a.id
}


// PRIVATE ROUTE TABLE ASSOCIATIONS FOR SUBNETS IN AVAILABILITY ZONE B
resource "aws_route_table_association" "web_b" {

  subnet_id = aws_subnet.web_b.id

  route_table_id = aws_route_table.private_b.id
}

resource "aws_route_table_association" "app_b" {

  subnet_id = aws_subnet.app_b.id

  route_table_id = aws_route_table.private_b.id
}

resource "aws_route_table_association" "db_b" {

  subnet_id = aws_subnet.db_b.id

  route_table_id = aws_route_table.private_b.id
}