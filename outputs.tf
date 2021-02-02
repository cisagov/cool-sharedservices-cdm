output "venom_customer_gateway" {
  value       = aws_customer_gateway.venom
  description = "The gateway for the site-to-site VPN connection to VENOM."
}

output "venom_vpn_connection" {
  value       = aws_vpn_connection.venom
  description = "The site-to-site VPN connection to VENOM."
}
