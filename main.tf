terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.61.0"
    }
  }
}

provider "aws" {
  # Configuration options
   region     = "ap-southeast-1"
  # access_key = ""
  # secret_key = ""
}

data "aws_ami" "tfami" {
   most_recent      = true
   owners           = ["amazon"]
 
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
}
}
  resource "aws_instance" "web" {
    count = 2
  ami           = data.aws_ami.tfami.id
  instance_type = "t2.micro"
  key_name = "master"

  tags = {
    Name = "tf-${count.index}"
  }
}
output "instance-ip-0" {
  value = aws_instance.web[0].public_ip
}
output "instance-ip-1" {
  value = aws_instance.web[1].public_ip
}

output "ami" {
  value = aws_instance.web[1].ami
}