output "dns_from_venom_security_group" {
  value       = aws_security_group.dns_from_venom
  description = "The security group that allows inbound DNS requests from the VENOM environment."
}

output "dns_to_venom_security_group" {
  value       = aws_security_group.dns_to_venom
  description = "The security group that allows outbound DNS requests to the VENOM environment."
}

output "route53_resolver_endpoint_from_venom" {
  value       = aws_route53_resolver_endpoint.from_venom
  description = "The security group that allows inbound DNS requests from the VENOM environment."
}

output "route53_resolver_endpoint_to_venom" {
  value       = aws_route53_resolver_endpoint.to_venom
  description = "The security group that allows outbound DNS requests to the VENOM environment."
}

output "venom_customer_gateway" {
  value       = aws_customer_gateway.venom
  description = "The gateway for the site-to-site VPN connection to VENOM."
}

output "venom_prefix_list" {
  value       = aws_ec2_managed_prefix_list.venom
  description = "A prefix list for the VENOM CIDRs."
}

output "venom_security_group" {
  value       = aws_security_group.venom
  description = "A security group that allows for all necessary communications between the VENOM agents and the VENOM CIDRs."
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
