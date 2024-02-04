output "public_ip_my_instance" {
  value = aws_instance.my_instance.public_ip
}
