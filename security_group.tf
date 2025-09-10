# Security group for instances that run CDM agents (e.g., CrowdStrike
# Falconview, Tenable, etc.)
resource "aws_security_group" "cdm" {
  provider = aws.sharedservicesprovisionaccount

  description = "CDM"
  tags = {
    "Name" = "CDM"
  }
  vpc_id = data.terraform_remote_state.networking.outputs.vpc.id
}

resource "aws_security_group_rule" "cdm" {
  for_each = local.cdm_ports
  provider = aws.sharedservicesprovisionaccount

  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = each.value.from_port
  protocol          = each.value.proto
  security_group_id = aws_security_group.cdm.id
  to_port           = each.value.to_port
  type              = each.value.egress ? "egress" : "ingress"
}

# Allow HTTPS out anywhere.  This is necessary for the CrowdStrike
# Falcon sensor to phone home.
resource "aws_security_group_rule" "crowdstrike_falcon" {
  provider = aws.sharedservicesprovisionaccount

  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.cdm.id
  to_port           = 443
  type              = "egress"
}
