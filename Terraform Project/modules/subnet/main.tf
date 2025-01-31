resource "aws_subnet" "Subnet1" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet1_cidr
  availability_zone = var.avail_zone1
  map_public_ip_on_launch = true
}

resource "aws_subnet" "Subnet2" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet2_cidr
  availability_zone = var.avail_zone2
  map_public_ip_on_launch = true
}


