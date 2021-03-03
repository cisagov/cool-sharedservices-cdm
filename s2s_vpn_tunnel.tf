# ------------------------------------------------------------------------------
# Create a tunnel to VENOM
# ------------------------------------------------------------------------------

resource "aws_customer_gateway" "venom" {
  provider = aws.sharedservicesprovisionaccount

  bgp_asn    = 65000 # Unused
  ip_address = var.venom_tunnel_ip
  tags = merge(
    var.tags,
    {
      "Name" = "VENOM site-to-site VPN gateway"
    },
  )
  type = "ipsec.1"
}

resource "aws_vpn_connection" "venom" {
  provider = aws.sharedservicesprovisionaccount

  customer_gateway_id = aws_customer_gateway.venom.id
  # These two resources seem to want a /32, which is incorrect.  See this GitHub issue:
  # https://github.com/hashicorp/terraform-provider-aws/issues/16879
  #
  # This doesn't really matter (I hope), since I will define what
  # traffic flows into the customer gateway via TGW routing tables.
  #
  # We should be able to make use of these parameters once this pull
  # request is approved and merged:
  # https://github.com/hashicorp/terraform-provider-aws/pull/17573
  #
  # local_ipv4_network_cidr = var.venom_cidrs["East"]
  # remote_ipv4_network_cidr = data.terraform_remote_state.networking.outputs.vpc.cidr_block
  static_routes_only = true
  tags = merge(
    var.tags,
    {
      "Name" = "VENOM site-to-site VPN connection"
    },
  )
  transit_gateway_id                   = data.terraform_remote_state.networking.outputs.transit_gateway.id
  tunnel_inside_ip_version             = "ipv4"
  tunnel1_ike_versions                 = ["ikev2"]
  tunnel1_phase1_dh_group_numbers      = [14]
  tunnel1_phase1_encryption_algorithms = ["AES256"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-384"]
  tunnel1_phase1_lifetime_seconds      = 28800 # 8 hours
  tunnel1_phase2_dh_group_numbers      = [14]
  tunnel1_phase2_encryption_algorithms = ["AES256"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-384"]
  tunnel1_phase2_lifetime_seconds      = 3600
  tunnel1_preshared_key                = var.venom_vpn_preshared_key
  tunnel2_ike_versions                 = ["ikev2"]
  tunnel2_phase1_dh_group_numbers      = [14]
  tunnel2_phase1_encryption_algorithms = ["AES256"]
  tunnel2_phase1_integrity_algorithms  = ["SHA2-384"]
  tunnel2_phase1_lifetime_seconds      = 28800 # 8 hours
  tunnel2_phase2_dh_group_numbers      = [14]
  tunnel2_phase2_encryption_algorithms = ["AES256"]
  tunnel2_phase2_integrity_algorithms  = ["SHA2-384"]
  tunnel2_phase2_lifetime_seconds      = 3600
  tunnel2_preshared_key                = var.venom_vpn_preshared_key
  type                                 = aws_customer_gateway.venom.type
}
