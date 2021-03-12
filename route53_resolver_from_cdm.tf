# ------------------------------------------------------------------------------
# Create Route53 resolver that allows the VENOM environment to resolve
# DNS entries in our environment
# ------------------------------------------------------------------------------

# Security group for Route53 resolver that allows inbound DNS queries
# from the VENOM environment.
resource "aws_security_group" "dns_from_venom" {
  provider = aws.sharedservicesprovisionaccount

  vpc_id = data.terraform_remote_state.networking.outputs.vpc.id

  description = "VENOM DNS - From VENOM"
  tags = merge(
    var.tags,
    {
      "Name" = "VENOM DNS - From VENOM"
    },
  )
}
resource "aws_security_group_rule" "dns_from_venom" {
  for_each = toset(local.tcp_and_udp)
  provider = aws.sharedservicesprovisionaccount

  security_group_id = aws_security_group.dns_from_venom.id
  type              = "ingress"
  cidr_blocks       = [var.venom_cidr]
  protocol          = each.key
  from_port         = 53
  to_port           = 53
}

resource "aws_route53_resolver_endpoint" "from_venom" {
  provider = aws.sharedservicesprovisionaccount

  direction = "INBOUND"

  dynamic "ip_address" {
    for_each = data.terraform_remote_state.networking.outputs.private_subnets

    content {
      subnet_id = ip_address.value.id
    }
  }

  name = "From VENOM"
  security_group_ids = [
    aws_security_group.dns_from_venom.id,
  ]
  tags = merge(
    var.tags,
    {
      "Name" = "Route53 resolver - from VENOM"
    },
  )
}
