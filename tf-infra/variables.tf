variable "region" {
    type = string
    default = "ca-central-1"
}

variable "AWS_ACCESS_KEY_ID" {
  default   = ""
  sensitive = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  default   = ""
  sensitive = true
}

variable "ecr_image_frontend" {
    default = ""
}

variable "ecr_image_backend" {
    default = ""
}

variable "account_id" {
    type = string
}

variable "POSTGRES_USER" {
    type = string
}

variable "POSTGRES_PASSWORD" {
    type = string
}

variable "DB_NAME" {
    type = string
}

/* variable "aws_vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

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

variable "map_public_ip_on_launch" {
    type = bool
    default = true
}

variable "aws_route_table_route_cidr" {
    type = string
    default = "0.0.0.0/0"
} */

variable "aws_security_group_description" {
    type = string
}

variable "aws_security_group_description_ecs" {
    type = string
}

variable "security_group_cidr_blocks" {
    type = list(string)
}

variable "aws_key_pair_name" {
    type = string
}

variable "aws_key_pair_public" {
    type = string
}
