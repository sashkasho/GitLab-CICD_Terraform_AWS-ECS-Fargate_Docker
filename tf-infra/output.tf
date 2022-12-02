/* output "server_ip" {
    value = aws_instance.test_server[0].public_ip
} */
/* output "server_endpoint" {
    value = "http://${aws_instance.test_server[0].public_dns}"
} */
/* output "db_instance_endpoint" {
  value = aws_db_instance.db.endpoint
} */

output "alb_hostname" {
  value = aws_alb.test-alb.dns_name
}