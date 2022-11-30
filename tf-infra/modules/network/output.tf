output "vpc_id" {
    value = aws_vpc.test_vpc.id
}
/* output "subnet_id" {
    #value = ["aws_subnet.test_subnet.id"]
    #value = ["${aws_subnet.test_subnet.*.id}"]
    value = flatten([for i in aws_subnet.test_subnet[*] : i.id[*]])
} */
output "public_subnets_id" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnet.*.id
}
/* output "private_subnets_id" {
  value = ["${aws_subnet.private_subnet.*.id}"]
} */

/* output "default_sg_id" {
  value = aws_security_group.default.id
} */

/* output "security_groups_ids" {
  value = ["${aws_security_group.default.id}"]
} */

/* output "public_route_table" {
  value = aws_route_table.public.id
} */
