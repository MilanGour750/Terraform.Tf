resource "aws_vpc" "ProjectVPC" {
  cidr_block = var.cidrBlock
}

resource "aws_subnet" "Subnet1" {
  vpc_id = aws_vpc.ProjectVPC.id
  cidr_block = var.CIDRblock
  availability_zone = var.AvailZone1
  map_public_ip_on_launch = true
}

resource "aws_subnet" "Subnet2" {
  vpc_id = aws_vpc.ProjectVPC.id
  cidr_block = var.CIDRblock
  availability_zone = var.AvailZone2
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "GatewayProj" {
  vpc_id = aws_vpc.ProjectVPC.id
}

resource "aws_route_table" "RouteTable" {
    vpc_id = aws_vpc.ProjectVPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.GatewayProj.id
    }
}

resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.Subnet1.id
    route_table_id = aws_route_table.RouteTable.id
}
resource "aws_route_table_association" "rta2" {
    subnet_id = aws_subnet.Subnet2.id
    route_table_id = aws_route_table.RouteTable.id
}

resource "aws_security_group" "webSG" {
  name = "Web_SG"
  
  vpc_id = aws_vpc.ProjectVPC.id

  ingress  {
    description="Inbound Rules"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description="SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

resource "aws_s3_bucket" "s3Project" {
    bucket = "bucket-for-milans-tf-project"
}

resource "aws_instance" "ProjectWS1" {
  instance_type = "t2.micro"
  ami = "ami-04b4f1a9cf54c11d0"

  vpc_security_group_ids = [aws_security_group.webSG.id]
  subnet_id = aws_subnet.Subnet1.id

  user_data = base64encode(file("userdata.sh"))
}

resource "aws_instance" "ProjectWS2" {
  instance_type = "t2.micro"
  ami = var.AMI_ID

  vpc_security_group_ids = [aws_security_group.webSG.id]
  subnet_id = aws_subnet.Subnet2.id

  user_data = base64encode(file("userdata1.sh"))
}

resource "aws_alb" "myloadBalancer" {
  name = "myalb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.webSG.id]
  subnets = [aws_subnet.Subnet1.id, aws_subnet.Subnet2.id]

}

resource "aws_lb_target_group" "tg" {
  name = "myTG"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.ProjectVPC.id

  health_check {
    path = "/"
    port = "traffic-port"

  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.ProjectWS1.id
  port = 80
}
resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.ProjectWS2.id
  port = 80
}
resource "aws_lb_listener" "myListner" {
  load_balancer_arn = aws_alb.myloadBalancer.arn
  port = 90
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type = "forward"
  }
}

output "LoadBalancerDNS" {
  value = aws_alb.myloadBalancer.dns_name
}