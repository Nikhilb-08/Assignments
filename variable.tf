variable "region"{
	default = "eu-west-2"
}
variable "access_key" {
	default = "AKIA2UC3AXUB7RK6XK37"
}
variable "secret_key"{
	default = "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"
}
variable "ami" {
  type = string
  default = "ami-0f8f99aa5fa000138"
}
variable "key_name" {
	default = "linux-key"
}
variable "cidr_blockpubsub" {
	default = "10.0.1.0/24"
}            
variable "cidr_blockvpc" {
	default = "10.0.0.0/16"
}
variable "vpc_id" { 
	default = "aws_vpc.qa_vpc.id"
}
variable "subnet_id"{
	default = "aws_subnet.public_subnet.id"
}
variable "instance_type" {
	default = "t2.micro"
}
