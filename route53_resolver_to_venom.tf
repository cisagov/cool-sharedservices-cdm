# ------------------------------------------------------------------------------
# Create Route53 resolver that allows us to resolve DNS entries in the
# VENOM environment
# ------------------------------------------------------------------------------

# Security group for Route53 resolver that allows outbound DNS queries
# to the VENOM environment.
resource "aws_security_group" "dns_to_venom" {
  provider = aws.sharedservicesprovisionaccount

  vpc_id = data.terraform_remote_state.networking.outputs.vpc.id

  description = "VENOM DNS - To VENOM"
  tags = merge(
    var.tags,
    {
      "Name" = "VENOM DNS - To VENOM"
    },
  )
}
resource "aws_security_group_rule" "dns_to_venom" {
  for_each = toset(local.tcp_and_udp)
  provider = aws.sharedservicesprovisionaccount

  security_group_id = aws_security_group.dns_to_venom.id
  type              = "egress"
  prefix_list_ids   = [aws_ec2_managed_prefix_list.venom.id]
  protocol          = each.key
  from_port         = 53
  to_port           = 53
}

resource "aws_route53_resolver_endpoint" "to_venom" {
  provider = aws.sharedservicesprovisionaccount

  direction = "OUTBOUND"

  dynamic "ip_address" {
    for_each = data.terraform_remote_state.networking.outputs.private_subnets

    content {
      subnet_id = ip_address.value.id
    }
  }

  name = "To VENOM"
  security_group_ids = [
    aws_security_group.dns_to_venom.id,
  ]
  tags = merge(
    var.tags,
    {
      "Name" = "Route53 resolver - to VENOM"
    },
  )
}
