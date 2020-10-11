# Security Group
resource "aws_security_group" "allow_all" {
  name        = "${var.Project_Prefix}_allow_all"
  description = "Allow All Ingress and Egress traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.Project_Prefix}_allow_all"
  }
}

resource "aws_security_group_rule" "ingress_any" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_all.id
  description       = "Anything from Anywhere"
}

resource "aws_security_group_rule" "egress_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_all.id
  description       = "Anything to Anywhere"
}

## Outputs
output "aws_security_group_allow_all" {
  value = aws_security_group.allow_all
}

output "aws_security_group_allow_all_id" {
  value = aws_security_group.allow_all.id
}

output "aws_security_group_allow_all_name" {
  value = aws_security_group.allow_all.name
}