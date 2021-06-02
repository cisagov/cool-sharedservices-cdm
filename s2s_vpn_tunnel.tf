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

  customer_gateway_id     = aws_customer_gateway.cdm.id
  local_ipv4_network_cidr = var.cdm_cidr
  # The cidrsubnet() here is because we want to give CDM as small a
  # subnet as possible, since they are assuming there are no
  # duplicates across the CISA enterprise.  All the instances that
  # interest them (the OpenVPN and FreeIPA instances) are contained in
  # the first 16 /24 subnets of the VPC's /16 CIDR block; for
  # instance, if the VPC CIDR block is 10.10.0.0/16, then the
  # instances of interest are contained in 10.10.0.0/24, 10.10.1.0/24,
  # ..., 10.10.15.0/24, which is equivalent to 10.10.0.0/20 or
  # cidrsubnet("10.10.0.0/16", 4, 0).
  #
  # See also:
  # https://www.terraform.io/docs/language/functions/cidrsubnet.html
  remote_ipv4_network_cidr = cidrsubnet(data.terraform_remote_state.networking.outputs.vpc.cidr_block, 4, 0)
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
