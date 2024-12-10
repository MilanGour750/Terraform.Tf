provider "aws" {
    region = "us-east-1"
}   

module "ec2Insatnce" {
    source = "./modules/EC2Instance"
    ami_value = "ami-0e2c8caa4b6378d8c"
    instanceType = "t2.micro"
}