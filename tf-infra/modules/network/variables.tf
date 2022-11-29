variable "aws_vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
}
/* variable "aws_subnet_cidr_block" {
  type = string
} */
variable "availability_zone" {
    type = list(string)
    default = [ "ca-central-1a", "ca-central-1b", "ca-central-1d" ]
}
variable "enable_dns_support" {
  type = bool
  default = true
}
variable "enable_dns_hostnames" {
  type = bool
  default = true
}
/* variable "map_public_ip_on_launch" {
  type = bool
  default = true
} */
variable "aws_route_table_route_cidr" {
    type = string
    default = "0.0.0.0/0"
}