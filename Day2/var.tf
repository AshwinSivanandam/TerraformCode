variable "ami_id" {

    description = "Passing AMI Value"
    default = "ami-0bdd88bd06d16ba03"
    type = string
  
}

variable "type" {
  
  description = "Passing value to Instance Type"
  default = "t2.micro"
  type = string
  
}