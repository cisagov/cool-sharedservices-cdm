# ------------------------------------------------------------------------------
# Create Route53 resolver that allows the CDM environment to resolve
# DNS entries in our environment
# ------------------------------------------------------------------------------

# Security group for Route53 resolver that allows inbound DNS queries
# from the CDM environment.
resource "aws_security_group" "dns_from_cdm" {
  provider = aws.sharedservicesprovisionaccount

  description = "CDM DNS - From CDM"
  tags = {
    "Name" = "CDM DNS - From CDM"
  }
  vpc_id = data.terraform_remote_state.networking.outputs.vpc.id
}
resource "aws_security_group_rule" "dns_from_cdm" {
  for_each = toset(local.tcp_and_udp)
  provider = aws.sharedservicesprovisionaccount

  cidr_blocks       = [var.cdm_cidr]
  from_port         = 53
  protocol          = each.key
  security_group_id = aws_security_group.dns_from_cdm.id
  to_port           = 53
  type              = "ingress"
}

resource "aws_route53_resolver_endpoint" "from_cdm" {
  provider = aws.sharedservicesprovisionaccount

  direction = "INBOUND"

  dynamic "ip_address" {
    for_each = data.terraform_remote_state.networking.outputs.private_subnets

    content {
      subnet_id = ip_address.value.id
    }
  }

  name = "From CDM"
  security_group_ids = [
    aws_security_group.dns_from_cdm.id,
  ]
  tags = {
    "Name" = "Route53 resolver - from CDM"
  }
}
