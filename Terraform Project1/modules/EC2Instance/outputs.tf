output "public-ip-address" {
  value = aws_instance.example_instance.public_ip
}