provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
resource "aws_vpc" "qa_vpc" {
  cidr_block           = var.cidr_blockvpc
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.qa_vpc.id
}                                                                   
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.qa_vpc.id
  cidr_block              = var.cidr_blockpubsub
  map_public_ip_on_launch = true
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.qa_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
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
resource "aws_instance" "public_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  tags = {
    Name = "Public_Instance"
  }
}

output "instance_id" {
  value = aws_instance.public_instance.id
}

output "public_ip_address" {
  value = aws_instance.public_instance.public_ip
}

