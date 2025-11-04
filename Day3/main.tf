resource "aws_instance" "name" {
  ami = "ami-0bdd88bd06d16ba03"
  instance_type = "t2.micro"
  tags = {
    Name = "Devvv"
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "ashwin.28111994"
}

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC1"
  }
}