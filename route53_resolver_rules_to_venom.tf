# ------------------------------------------------------------------------------
# Create Route53 resolver rules that allow us to resolve DNS entries
# in the VENOM environment
# ------------------------------------------------------------------------------

resource "aws_route53_resolver_rule" "to_venom" {
  provider = aws.sharedservicesprovisionaccount
  for_each = toset(var.venom_domains)

  domain_name          = each.key
  name                 = "Resolve VENOM domain"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.to_venom.id

  dynamic "target_ip" {
    for_each = toset(var.venom_dns_ips)

    content {
      ip = target_ip.key
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = "VENOM DNS - To VENOM"
    },
  )
}

# Associate the rules with our VPC
resource "aws_route53_resolver_rule_association" "to_venom" {
  provider = aws.sharedservicesprovisionaccount
  for_each = aws_route53_resolver_rule.to_venom

  resolver_rule_id = each.value.id
  vpc_id           = data.terraform_remote_state.networking.outputs.vpc.id
}

# Create resource shares for the rules.  These will be used by the
# userservices account.
resource "aws_ram_resource_share" "to_venom" {
  provider = aws.sharedservicesprovisionaccount
  for_each = aws_route53_resolver_rule.to_venom

  allow_external_principals = false
  name                      = each.value.name

  tags = merge(
    var.tags,
    {
      "Name" = "VENOM DNS - To VENOM"
    },
  )
}
