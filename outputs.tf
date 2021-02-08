output "venom_customer_gateway" {
  value       = aws_customer_gateway.venom
  description = "The gateway for the site-to-site VPN connection to VENOM."
}

output "venom_tgw_route_table" {
  value       = aws_ec2_transit_gateway_route_table.venom
  description = "The custom Transit Gateway route table for the VENOM VPN connection."
}

output "venom_tgw_route_table_association" {
  value       = aws_ec2_transit_gateway_route_table_association.venom
  description = "The association between the VENOM VPN connection and its custom Transit Gateway route table."
}

output "venom_vpn_connection" {
  value       = aws_vpn_connection.venom
  description = "The site-to-site VPN connection to VENOM."
}
