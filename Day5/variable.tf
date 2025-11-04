variable "ami_id" {

    description = "AMI ID of the Instance"
    default = "ami-0bdd88bd06d16ba03"
    type = string
  
}

variable "type" {

    description = "Instance Type"
    default = "t2.micro"
    type = string
  
}