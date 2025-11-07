resource "aws_instance" "name" {
  ami           = "ami-0157af9aea2eef346"
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.subnet1.id


}

data "aws_subnet" "subnet1" {

  filter {
    name   = "tag:Name"
    values = ["subnet1"]
  }

}