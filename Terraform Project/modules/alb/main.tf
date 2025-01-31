resource "aws_alb" "myloadBalancer" {
  name = "myalb"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.security_group_id]
  subnets = [var.subnet1_id, var.subnet2_id]
}


