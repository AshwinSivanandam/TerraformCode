#Creating VPC
resource "aws_vpc" "vpc_main" {

    cidr_block = "172.0.0.0/16"
    tags = {
      Name = "VPC1"
    }
    enable_dns_hostnames = true
  
}

#Creating IGW and attaching it to VPC
resource "aws_internet_gateway" "igw_main" {

    tags = {
      Name = "IGW1"
    }

    vpc_id = aws_vpc.vpc_main.id
  
}

# for frontend load balancer 
resource "aws_subnet" "pub1"  {
    vpc_id = aws_vpc.vpc_main.id
    tags = {
        Name = "PUBS1A"
    }

    cidr_block = "172.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true  # for auto asign public ip for subnet

}

# for frontend load balancer 
resource "aws_subnet" "pub2" {
    vpc_id = aws_vpc.vpc_main.id
    tags = {
      Name = "PUBS2B"
    }
    cidr_block = "172.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
  
}

#for frontend server
resource "aws_subnet" "pri3" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "172.0.3.0/24"
    availability_zone = "us-east-1a"
    tags = {
    Name = "PRVT3A"
  }

}

#for frontend server
resource "aws_subnet" "pri4" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "172.0.4.0/24"
    availability_zone = "us-east-2a"
    tags = {
    Name = "PRVT4B"
  }

}

#for Backend server
resource "aws_subnet" "pri5" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "172.0.5.0/24"
    availability_zone = "us-east-1a"
    tags = {
    Name = "PRVT5A"
  }

}

#for Backend server
resource "aws_subnet" "pri6" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "172.0.6.0/24"
    availability_zone = "us-east-2b"
    tags = {
    Name = "PRVT6B"
  }

}

#for rds
resource "aws_subnet" "pri7" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "172.0.7.0/24"
    availability_zone = "us-east-1a"
    tags = {
    Name = "PRVT7A"
  }

}

#for rds
resource "aws_subnet" "pri8" {
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = "172.0.8.0/24"
    availability_zone = "us-east-1b"
    tags = {
    Name = "PRVT8B"
  }

}

#Creating Public Route Table
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vpc_main.id
    tags = {
      Name = "PUBLIC_RT"
    }
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_main.id
    }
  
}


#attach public RT to pub1
resource "aws_route_table_association" "public-1a" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.pub1.id
  
}

#attach public RT to pub2
resource "aws_route_table_association" "public-1b" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.pub2.id
  
}

# creating elastic ip for nat gateway
resource "aws_eip" "eip" {
  
}

#create NAT Gateway
resource "aws_nat_gateway" "nat" {
  tags = {
    Name = "NAT1"
  }
  subnet_id = aws_subnet.pub1
  connectivity_type = "public"
  allocation_id = aws_eip.eip.id

}

#Creating Private Route Table
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.vpc_main.id
    tags = {
      Name = "PRIVATE_RT"
    }

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.nat.id
    }
  
}


#attach private RT to pri3
resource "aws_route_table_association" "name" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.pri3.id
}

#attach private RT to pri4
resource "aws_route_table_association" "name" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.pri4.id
}

#attach private RT to pri5
resource "aws_route_table_association" "name" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.pri5.id
}

#attach private RT to pri6
resource "aws_route_table_association" "name" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.pri6.id
}

#attach private RT to pri7
resource "aws_route_table_association" "name" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.pri7.id
}

#attach private RT to pri8
resource "aws_route_table_association" "name" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.pri8.id
}