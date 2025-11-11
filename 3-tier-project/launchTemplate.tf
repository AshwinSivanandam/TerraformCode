data "aws_ami" "ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["Test1"]
  }

}

resource "aws_launch_template" "name" {
  name                   = "frontend-terraform"
  description            = "frontend-terraform"
  image_id               = data.aws_ami.ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.frontend-server-sg]
  key_name               = "us-east-1"
  update_default_version = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "frontend-terraform"
    }
  }

}


# Launch Template Resource
resource "aws_launch_template" "backend" {
  name                   = "backend-terraform"
  description            = "backend-terraform"
  image_id               = data.aws_ami.example1.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.backend-server-sg.id]
  key_name               = "us-east-1"
  #user_data = filebase64("${path.module}/backend-lt.sh")
  #default_version = 1
  update_default_version = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "backend-terraform"
    }
  }
}