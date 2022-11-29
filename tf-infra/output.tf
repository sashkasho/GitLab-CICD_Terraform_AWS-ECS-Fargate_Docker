/* output "server_ip" {
    value = aws_instance.test_server[0].public_ip
} */
/* output "server_endpoint" {
    value = "http://${aws_instance.test_server[0].public_dns}"
} */
output "alb_hostname" {
  value = aws_alb.test-alb.dns_name
}