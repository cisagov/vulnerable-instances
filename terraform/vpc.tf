# The vulnerable VPC
resource "aws_vpc" "vuln_vpc" {
  cidr_block = "10.10.10.0/28"

  tags = merge(
    var.tags,
    {
      "Name" = "Vulnerable VPC"
    },
  )
}

# Vulnerable (only) subnet of the VPC
resource "aws_subnet" "vuln_subnet" {
  vpc_id            = aws_vpc.vuln_vpc.id
  cidr_block        = "10.10.10.0/28"
  availability_zone = "${var.aws_region}${var.aws_availability_zone}"

  depends_on = [aws_internet_gateway.vuln_igw]

  tags = merge(
    var.tags,
    {
      "Name" = "Vulnerable Subnet"
    },
  )
}

# The internet gateway for the VPC
resource "aws_internet_gateway" "vuln_igw" {
  vpc_id = aws_vpc.vuln_vpc.id

  tags = merge(
    var.tags,
    {
      "Name" = "Vulnerable IGW"
    },
  )
}

# Default route table for VPC, which routes all external traffic
# through the internet gateway
resource "aws_default_route_table" "vuln_default_route_table" {
  default_route_table_id = aws_vpc.vuln_vpc.default_route_table_id

  tags = merge(
    var.tags,
    {
      "Name" = "Vulnerable Route Table"
    },
  )
}

# Default route: Route all external traffic through the internet
# gateway
resource "aws_route" "vuln_default_route_external_traffic_through_internet_gateway" {
  route_table_id         = aws_default_route_table.vuln_default_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vuln_igw.id
}

# ACL for the vulnerable (only) subnet
resource "aws_network_acl" "vuln_acl" {
  vpc_id = aws_vpc.vuln_vpc.id

  subnet_ids = [
    aws_subnet.vuln_subnet.id,
  ]

  tags = merge(
    var.tags,
    {
      "Name" = "Vulnerable ACL"
    },
  )
}

# Security group for the vulnerable Ubuntu 14.04 instance
resource "aws_security_group" "vuln_ubuntu1404_sg" {
  vpc_id = aws_vpc.vuln_vpc.id

  tags = merge(
    var.tags,
    {
      "Name" = "Vulnerable Ubuntu 14.04"
    },
  )
}
