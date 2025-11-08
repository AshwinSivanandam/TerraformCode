provider "aws" {
  
}

resource "aws_key_pair" "key" {
  key_name = "Test"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "ec2" {

  ami = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  key_name = aws_key_pair.example.key_name
  
}