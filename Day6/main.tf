resource "aws_instance" "name" {

    ami = "ami-0bdd88bd06d16ba03"
    instance_type = "t2.micro"

# create_before_destroy = true will create the new resources first before destrying the existing ones.
    lifecycle {
      create_before_destroy = false
    }

# ignore_changes will ignore the changes made in Remote(Cloud) directly.
    lifecycle {
      ignore_changes = [ tags,  ]
    }

# prevent_destroy = true will prevent the resources to be destroyed when terraform destroy is applied.
    lifecycle {
      prevent_destroy = false
    }
  
}