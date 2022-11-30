# NETWORK BLOCKS

# VPC
resource "aws_vpc" "test_vpc" {
  cidr_block       = var.aws_vpc_cidr_block
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "app_vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  count = length(var.availability_zone)
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "app_public_subnet-${count.index + 1}"
  }
}

# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "app_igw"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = var.aws_route_table_route_cidr
    gateway_id = aws_internet_gateway.test_igw.id
  }

  tags = {
    Name = "app_public_rt"
  }
}

# Route table associations for Public Subnets
resource "aws_route_table_association" "public_rt_assoc" {
  count = length(var.availability_zone)
  route_table_id = aws_route_table.public_rt.id
  #subnet_id = aws_subnet.test_subnet[count.index].id
  subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  count = length(var.availability_zone)
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.0.${count.index + length(var.availability_zone)}.0/24"
  availability_zone = element(var.availability_zone, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "app_private_subnet-${count.index + 1}"
  }
}

# Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  count = length(var.availability_zone)
  vpc        = true
  depends_on = [aws_internet_gateway.test_igw]
}

# NAT for Private Subnet
resource "aws_nat_gateway" "nat" {
  count = length(var.availability_zone)
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)

  tags = {
    Name = "app_nat-${count.index}"
  }
}

# Route Table for Private Subnet
resource "aws_route_table" "private_rt" {
  count = length(var.availability_zone)
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = var.aws_route_table_route_cidr
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }

  tags = {
    Name = "app_private_rt-${count.index}"
  }
}

# Route table associations for Private Subnets
resource "aws_route_table_association" "private_rt_assoc" {
  count = length(var.availability_zone)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
  #subnet_id = aws_subnet.test_subnet[count.index].id
  subnet_id = element(aws_subnet.private_subnet.*.id, count.index)
}
