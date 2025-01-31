resource "aws_instance" "ProjectWS1" {
  instance_type = "t2.micro"
  ami = var.ami_id
  vpc_security_group_ids = [var.security_group_id]
  subnet_id = var.subnet1_id
  user_data = base64encode(file(var.user_data))
}

resource "aws_instance" "ProjectWS2" {
  instance_type = "t2.micro"
  ami = var.ami_id
  vpc_security_group_ids = [var.security_group_id]
  subnet_id = var.subnet2_id
  user_data = base64encode(file(var.user_data2))
}





