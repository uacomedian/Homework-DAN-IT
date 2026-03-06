provider "aws" {
  region = "eu-central-1" 
}

# VPC & Network
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "hw19-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1a"
}

# Routing
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "pub_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "priv_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "ssh_sg" {
  name   = "hw19-ssh-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public_ec2" {
  ami           = "ami-0de02246788e4a354"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "hw17-key"
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]
  tags = { Name = "Public-Node" }
}

resource "aws_instance" "private_ec2" {
  ami           = "ami-0de02246788e4a354"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  key_name      = "hw17-key"
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]
  tags = { Name = "Private-Node" }
}

output "public_ip" {
  value = aws_instance.public_ec2.public_ip
}

output "private_ip" {
  value = aws_instance.private_ec2.private_ip
}