#Create VPC

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cust-vpc"
  }

}
#Create Subnets

resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    tags = {
        Name = "cust-subnet-1-public"
    }
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "name2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "cust-subnet-2-private"
    }
    availability_zone = "us-east-1b"
}
#Create IGW and attach to VPC
resource "aws_internet_gateway" "name" {
  
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "IGW"
  }
}
#Create RT and edit routes

resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id

  route  {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.name.id
  }


}
#Create Subnet Association
resource "aws_route_table_association" "name" {
  subnet_id = aws_subnet.name.id
  route_table_id = aws_route_table.name.id
}
#Create SG

resource "aws_security_group" "name" {

    name   = "allow_tls"
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "dev-sg"
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}
#Create Servers

resource "aws_instance" "name" {
  ami = var.ami_id
  instance_type = var.type
  subnet_id = aws_subnet.name.id
  vpc_security_group_ids = [aws_security_group.name.id]
  associate_public_ip_address = true
  tags = {
    Name = "Public Instance"
  }
}

#Create EIP

#Create NAT GW

#Create RT

#Create RT Association