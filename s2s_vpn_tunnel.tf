# ------------------------------------------------------------------------------
# Create a tunnel to CDM
# ------------------------------------------------------------------------------

resource "aws_customer_gateway" "cdm" {
  provider = aws.sharedservicesprovisionaccount

  bgp_asn    = 65000 # Unused
  ip_address = var.cdm_tunnel_ip
  tags = merge(
    var.tags,
    {
      "Name" = "CDM site-to-site VPN gateway"
    },
  )
  type = "ipsec.1"
}

resource "aws_vpn_connection" "cdm" {
  provider = aws.sharedservicesprovisionaccount

  customer_gateway_id      = aws_customer_gateway.cdm.id
  local_ipv4_network_cidr  = var.cdm_cidr
  remote_ipv4_network_cidr = data.terraform_remote_state.networking.outputs.vpc.cidr_block
  static_routes_only       = true
  tags = merge(
    var.tags,
    {
      "Name" = "CDM site-to-site VPN connection"
    },
  )
  transit_gateway_id       = data.terraform_remote_state.networking.outputs.transit_gateway.id
  tunnel_inside_ip_version = "ipv4"
  # Try to reconnect when we detect that the other side of the tunnel
  # is dead
  tunnel1_dpd_timeout_action           = "restart"
  tunnel1_ike_versions                 = ["ikev2"]
  tunnel1_phase1_dh_group_numbers      = [14]
  tunnel1_phase1_encryption_algorithms = ["AES256"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-384"]
  tunnel1_phase1_lifetime_seconds      = 28800 # 8 hours
  tunnel1_phase2_dh_group_numbers      = [14]
  tunnel1_phase2_encryption_algorithms = ["AES256"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-384"]
  tunnel1_phase2_lifetime_seconds      = 3600
  tunnel1_preshared_key                = var.cdm_vpn_preshared_key
  # Try to reconnect when we detect that the other side of the tunnel
  # is dead
  tunnel2_dpd_timeout_action           = "restart"
  tunnel2_ike_versions                 = ["ikev2"]
  tunnel2_phase1_dh_group_numbers      = [14]
  tunnel2_phase1_encryption_algorithms = ["AES256"]
  tunnel2_phase1_integrity_algorithms  = ["SHA2-384"]
  tunnel2_phase1_lifetime_seconds      = 28800 # 8 hours
  tunnel2_phase2_dh_group_numbers      = [14]
  tunnel2_phase2_encryption_algorithms = ["AES256"]
  tunnel2_phase2_integrity_algorithms  = ["SHA2-384"]
  tunnel2_phase2_lifetime_seconds      = 3600
  tunnel2_preshared_key                = var.cdm_vpn_preshared_key
  type                                 = aws_customer_gateway.cdm.type
}
