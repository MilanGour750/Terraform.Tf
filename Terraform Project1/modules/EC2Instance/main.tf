provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "example_instance" {
    ami = var.ami_value
    instance_type = var.instanceType
    
    tags = {
        
    }
}