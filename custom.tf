provider "aws" {
  region = "eu-west-2"
  access_key="AKIA2UC3AXUB7RK6XK37"
  secret_key="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" 
}
# Create VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
 }
# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.custom_vpc.id
 }
# Create Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id    	   = aws_vpc.custom_vpc.id
  availabilty_zone = "us-east-2a"
  cidr_block	   = "10.0.1.0/24"
  map_public_ip_on_launch = true
 }
# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id
 }
# Create Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.custom_vpc.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
      }
 }
# Associate Public Subnet with Route Table
resource "aws_route_table_association" "publicRTassociation" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
 }
# Create Security Group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.custom_vpc.id

  # Allow SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow HTTP access on port 8080
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow MySQL access
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow Memcached access
  ingress {
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow Redis access
  ingress {
    from_port   = 6379
    to_port     = 6379
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
#Launch EC2 instance in Public Subnet
resource "aws_instance" "myec2" {
  ami           = "ami-0f8f99aa5fa000138" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name	= "linux-key"

	tags = {
		   Name = "myec2"
	}
}

  

