# Allow ingress from trusted networks on all TCP ports
resource "aws_security_group_rule" "ubuntu1404_ingress_all_tcp_from_trusted" {
  security_group_id = aws_security_group.vuln_ubuntu1404_sg.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = var.trusted_ingress_networks_ipv4

  # ipv6_cidr_blocks = "${var.trusted_ingress_networks_ipv6}"
  from_port = 0
  to_port   = 65535
}

# Allow ingress from trusted networks on all UDP ports
resource "aws_security_group_rule" "ubuntu1404_ingress_all_udp_from_trusted" {
  security_group_id = aws_security_group.vuln_ubuntu1404_sg.id
  type              = "ingress"
  protocol          = "udp"
  cidr_blocks       = var.trusted_ingress_networks_ipv4

  # ipv6_cidr_blocks = "${var.trusted_ingress_networks_ipv6}"
  from_port = 0
  to_port   = 65535
}

# Allow ingress from trusted networks for all ICMP
resource "aws_security_group_rule" "ubuntu1404_ingress_all_icmp_from_trusted" {
  security_group_id = aws_security_group.vuln_ubuntu1404_sg.id
  type              = "ingress"
  protocol          = "icmp"
  cidr_blocks       = var.trusted_ingress_networks_ipv4
  from_port         = -1
  to_port           = -1
}

# Allow egress to trusted networks on all TCP ports
resource "aws_security_group_rule" "ubuntu1404_egress_all_tcp_from_trusted" {
  security_group_id = aws_security_group.vuln_ubuntu1404_sg.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = var.trusted_ingress_networks_ipv4

  # ipv6_cidr_blocks = "${var.trusted_ingress_networks_ipv6}"
  from_port = 0
  to_port   = 65535
}

# Allow egress to trusted networks on all UDP ports
resource "aws_security_group_rule" "ubuntu1404_egress_all_udp_from_trusted" {
  security_group_id = aws_security_group.vuln_ubuntu1404_sg.id
  type              = "egress"
  protocol          = "udp"
  cidr_blocks       = var.trusted_ingress_networks_ipv4

  # ipv6_cidr_blocks = "${var.trusted_ingress_networks_ipv6}"
  from_port = 0
  to_port   = 65535
}

# Allow egress to trusted networks for all ICMP
resource "aws_security_group_rule" "ubuntu1404_egress_all_icmp_from_trusted" {
  security_group_id = aws_security_group.vuln_ubuntu1404_sg.id
  type              = "egress"
  protocol          = "icmp"
  cidr_blocks       = var.trusted_ingress_networks_ipv4
  from_port         = -1
  to_port           = -1
}
