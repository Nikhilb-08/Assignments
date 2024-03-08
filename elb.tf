provider "aws"{
  region = "eu-west-2"
  access_key="AKIA2UC3AXUB7RK6XK37"
  secret_key="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" 
}
resource "aws_security_group" "elb-sg"{
		name = "elb-sg"
  #incoming traffic
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
resource "aws_instance" "first" {
	ami 		= "ami-0f8f99aa5fa000138"
	instance_type   = "t2.micro"
	key_name 	= "linux-key"
	security_groups = ["elb-sg"]
	user_data 	= <<EOF
	#!/bin/bash
	yum install httpd -y 
	service httpd start
	chkconfig httpd on 
	echo "HEY THIS IS MY WEB SERVER FIRST" > /var/www/html/index.html
	EOF
	tags = {
		Name = "first_web-server"
		source = "terraform"
		}
}	
resource "aws_instance" "second" {
	ami 		= "ami-0f8f99aa5fa000138"
	instance_type 	= "t2.micro"
	key_name 	= "linux-key"
	security_groups = ["elb-sg"]
	user_data 	= <<EOF
	#!/bin/bash
	yum install httpd -y 
	service httpd start
	chkconfig httpd on 
	echo "HEY THIS IS MY WEB SERVER SECOND" > /var/www/html/index.html
	EOF
	tags = {
		Name = "second_web-server"
		source = "terraform"
		}
	}
resource "aws_elb" "ram"{
	name 			   = "ram-elb"
	availability_zones 	   = ["ap-south-1a","ap-south-2b"]
	
   listener {
		instance_port 		= 80
		instance_protocol 	= "http"
		lb_port 		= 80
		lb_protocol		= "http"
	}
   health_check {
	healthy_threshold 		= 2
	unhealthy_threshold		= 2
	timeout				= 5
	target				= "HTTP:80/"
	interval			= 30
	}
	instances		        = ["${aws_instance.first.id}", "${aws_instance.second.id}"]
	cross_zone_load_balancing 	= true
	idle_timeout			= 40
	tags = {
		Name = "app-elb"
		}
}
