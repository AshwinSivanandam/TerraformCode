provider "aws" {

}

data "aws_subnet" "subnet1" {

  filter {
    name   = "tag:Name"
    values = ["dev"]
  }

}


data "aws_ami" "SelectAMI" {

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}

resource "aws_instance" "firstinstance" {

  ami           = data.aws_ami.SelectAMI.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.subnet1.id

}