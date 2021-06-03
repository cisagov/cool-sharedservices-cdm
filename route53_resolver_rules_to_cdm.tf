# ------------------------------------------------------------------------------
# Create Route53 resolver rules that allow us to resolve DNS entries
# in the CDM environment
# ------------------------------------------------------------------------------

resource "aws_route53_resolver_rule" "to_cdm" {
  provider = aws.sharedservicesprovisionaccount
  for_each = toset(var.cdm_domains)

  domain_name          = each.key
  name                 = "Resolve CDM domain"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.to_cdm.id

  dynamic "target_ip" {
    for_each = toset(var.cdm_dns_ips)

    content {
      ip = target_ip.key
    }
  }

  tags = {
    "Name" = "CDM DNS - To CDM"
  }
}

# Associate the rules with our VPC
resource "aws_route53_resolver_rule_association" "to_cdm" {
  provider = aws.sharedservicesprovisionaccount
  for_each = aws_route53_resolver_rule.to_cdm

  resolver_rule_id = each.value.id
  vpc_id           = data.terraform_remote_state.networking.outputs.vpc.id
}

# Create resource shares for the rules.  These will be used by the
# User Services account.
resource "aws_ram_resource_share" "to_cdm" {
  provider = aws.sharedservicesprovisionaccount
  for_each = aws_route53_resolver_rule.to_cdm

  allow_external_principals = false
  name                      = each.value.name

  tags = {
    "Name" = "CDM DNS - To CDM"
  }
}
