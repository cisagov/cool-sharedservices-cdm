# Prefix list for the VENOM CIDRs
resource "aws_ec2_managed_prefix_list" "venom" {
  provider = aws.sharedservicesprovisionaccount

  address_family = "IPv4"
  max_entries    = 2
  name           = "VENOM CIDRs"

  dynamic "entry" {
    for_each = var.venom_cidrs

    content {
      cidr        = entry.key
      description = entry.value
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = "VENOM CIDRs"
    },
  )
}
