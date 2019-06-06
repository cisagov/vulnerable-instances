# Allow ingress from anywhere via any protocol and port
# Restrictions by source IP are handled by the security group rules
resource "aws_network_acl_rule" "ingress_from_anywhere_via_any_port" {
  network_acl_id = aws_network_acl.vuln_acl.id
  egress         = false
  protocol       = "-1"
  rule_number    = 100
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# Allow egress to anywhere via any protocol and port
# Restrictions by source IP are handled by the security group rules
resource "aws_network_acl_rule" "egress_to_anywhere_via_any_port" {
  network_acl_id = aws_network_acl.vuln_acl.id
  egress         = true
  protocol       = "-1"
  rule_number    = 110
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}
