provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "exampleInstance3" {
    instance_type = "t2.micro"
    ami = "ami-0e2c8caa4b6378d8c"
}

resource "aws_s3_bucket" "s3_bucket" {
    bucket = "milan-bucket-demoterraform"
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}