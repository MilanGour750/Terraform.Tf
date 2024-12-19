provider "aws" {
    region = "us-east-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "aws_key_pair" "example" {
    key_name   = "deployment_key"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "MyVPC" {
    cidr_block = var.cidr
}

resource "aws_subnet" "Subnet1" {
    vpc_id                  = aws_vpc.MyVPC.id
    cidr_block              = "10.0.0.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true 
}

resource "aws_internet_gateway" "gateway1" {}

resource "aws_internet_gateway_attachment" "attach_gw" {
    vpc_id             = aws_vpc.MyVPC.id
    internet_gateway_id = aws_internet_gateway.gateway1.id
}

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.MyVPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gateway1.id
    }
}

resource "aws_route_table_association" "name" {
    subnet_id      = aws_subnet.Subnet1.id
    route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "webSG" {
    name   = "web"
    vpc_id = aws_vpc.MyVPC.id

    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
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

resource "aws_instance" "deployPython" {
    ami                    = "ami-08c40ec9ead489470" # Ubuntu AMI for us-east-1
    instance_type          = "t2.micro"
    key_name               = aws_key_pair.example.key_name
    vpc_security_group_ids = [aws_security_group.webSG.id]
    subnet_id              = aws_subnet.Subnet1.id   

    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file("~/.ssh/id_rsa")
        host        = self.public_ip
    }

    provisioner "file" {
        source      = "app.py"
        destination = "/home/ubuntu/app.py"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt update",
            "sudo apt-get install -y python3-pip",
            "cd /home/ubuntu",
            "sudo pip3 install --break-system-packages flask",
            "nohup sudo python3 app.py > app.log 2>&1 &"
        ]
    }

    tags = {
        Name = "DeployPythonInstance"
    }
}
