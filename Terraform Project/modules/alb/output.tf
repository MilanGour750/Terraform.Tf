output "alb_dns" {
  value = aws_alb.myloadBalancer.dns_name
}
