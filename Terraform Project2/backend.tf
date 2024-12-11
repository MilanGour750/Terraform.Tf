terraform {
    backend "s3" {
        bucket = "milan-bucket-demoterraform"
        key = "milan/terraform.tf"
        region = "us-east-1"
        dynamodb_table = "terraform-lock"
    }
}   