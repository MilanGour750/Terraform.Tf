variable "cidrBlock" {
  description = "This is the value of CIDR Block"
  default = "10.0.0.0/16"
}

variable "AvailZone1" {
  description = "This is the availability zone"
  default = "us-east-1a"
}

variable "AvailZone2" {
  description = "This is the availability zone"
  default = "us-east-1b"
}

variable "CIDRblock" {
  default = "10.0.0.0/24"
}

variable "AMI_ID" {
  description = "This is the AMI ID for our ec2"
  default = "ami-04b4f1a9cf54c11d0"
}