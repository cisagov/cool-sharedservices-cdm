# ------------------------------------------------------------------------------
# Create Route53 resolver that allows us to resolve DNS entries in the
# CDM environment
# ------------------------------------------------------------------------------

# Security group for Route53 resolver that allows outbound DNS queries
# to the CDM environment.
resource "aws_security_group" "dns_to_cdm" {
  provider = aws.sharedservicesprovisionaccount

  vpc_id = data.terraform_remote_state.networking.outputs.vpc.id

  description = "CDM DNS - To CDM"
  tags = merge(
    var.tags,
    {
      "Name" = "CDM DNS - To CDM"
    },
  )
}
resource "aws_security_group_rule" "dns_to_cdm" {
  for_each = toset(local.tcp_and_udp)
  provider = aws.sharedservicesprovisionaccount

  security_group_id = aws_security_group.dns_to_cdm.id
  type              = "egress"
  cidr_blocks       = [var.cdm_cidr]
  protocol          = each.key
  from_port         = 53
  to_port           = 53
}

resource "aws_route53_resolver_endpoint" "to_cdm" {
  provider = aws.sharedservicesprovisionaccount

  direction = "OUTBOUND"

  dynamic "ip_address" {
    for_each = data.terraform_remote_state.networking.outputs.private_subnets

    content {
      subnet_id = ip_address.value.id
    }
  }

  name = "To CDM"
  security_group_ids = [
    aws_security_group.dns_to_cdm.id,
  ]
  tags = merge(
    var.tags,
    {
      "Name" = "Route53 resolver - to CDM"
    },
  )
}
