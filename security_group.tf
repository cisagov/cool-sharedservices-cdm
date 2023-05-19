# Security group for instances that run CDM agents (Tanium and
# Tenable)
resource "aws_security_group" "cdm" {
  provider = aws.sharedservicesprovisionaccount

  vpc_id = data.terraform_remote_state.networking.outputs.vpc.id

  description = "CDM"
  tags = {
    "Name" = "CDM"
  }
}

resource "aws_security_group_rule" "cdm" {
  for_each = local.cdm_ports
  provider = aws.sharedservicesprovisionaccount

  security_group_id = aws_security_group.cdm.id
  type              = each.value.egress ? "egress" : "ingress"
  cidr_blocks       = [var.cdm_cidr]
  protocol          = each.value.proto
  from_port         = each.value.from_port
  to_port           = each.value.to_port
}

# Allow HTTPS out anywhere.  This is necessary for the CrowdStrike
# Falcon sensor to phone home.
resource "aws_security_group_rule" "crowdstrike_falcon" {
  provider = aws.sharedservicesprovisionaccount

  security_group_id = aws_security_group.cdm.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
}
