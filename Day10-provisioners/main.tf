provider "aws" {
    region = "us-east-1"
  
}

resource "aws_key_pair" "key_pair" {
    key_name = "task"
    public_key = file("~/.ssh/id_ed25519.pub")
  
}

#vpc
resource "aws_vpc" "vpc" {
    cidr_block = "172.0.0.0/24"
    tags = {
      Name = "VPC1"
    }

    enable_dns_support = true
    enable_dns_hostnames = true
  
}

#Subnet
resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.vpc
    cidr_block = "172.0.1.0/16"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
      Name = "publicSubnet1"
    }
  
}