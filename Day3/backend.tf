terraform {
  backend "s3" {
    bucket = "ashwin.28111994"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}