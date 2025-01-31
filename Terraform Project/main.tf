module "vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

module "subnet" {
  source = "./modules/subnet"
  vpc_id = module.vpc.vpc_id
  subnet1_cidr = "10.0.1.0/24"
  avail_zone1 = "us-east-1a"
  subnet2_cidr = "10.0.2.0/24"
  avail_zone2 = "us-east-1b"
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "instances" {
  source = "./modules/instances"
  subnet1_id = module.subnet.subnet1_id
  subnet2_id = module.subnet.subnet2_id
  security_group_id = module.security_group.security_group_id
  ami_id = "ami-04b4f1a9cf54c11d0"
  user_data = "userdata.sh"
  user_data2 = "userdata1.sh"
}

module "alb" {
  source = "./modules/alb"
  security_group_id = module.security_group.security_group_id
  subnet1_id = module.subnet.subnet1_id
  subnet2_id = module.subnet.subnet2_id
}

output "LoadBalancerDNS" {
  value = module.alb.alb_dns
}