provider "aws" {
  
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.18.0"
      #version = ">4.0<5.0" --> More than the version 4.0 but less than 5.0
      #version = ">4.0" --> More than the version 4.0
    }
  }
}