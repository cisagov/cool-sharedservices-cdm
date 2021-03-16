output "dns_from_cdm_security_group" {
  value       = aws_security_group.dns_from_cdm
  description = "The security group that allows DNS requests from the CDM environment."
}

output "dns_to_cdm_security_group" {
  value       = aws_security_group.dns_to_cdm
  description = "The security group that allows DNS requests to the CDM environment."
}

output "route53_resolver_endpoint_from_cdm" {
  value       = aws_route53_resolver_endpoint.from_cdm
  description = "The Route53 resolver that allows the CDM environment to resolve DNS queries in our environment."
}

output "route53_resolver_endpoint_to_cdm" {
  value       = aws_route53_resolver_endpoint.to_cdm
  description = "The Route53 resolver that allows us to resolve DNS queries in the CDM environment."
}

output "route53_resolver_rules_to_cdm" {
  value       = aws_route53_resolver_rule.to_cdm
  description = "The Route53 resolver rules that allow us to resolve DNS queries in the CDM environment."
}

output "route53_resolver_rules_to_cdm_ram_shares" {
  value       = aws_ram_resource_share.to_cdm
  description = "The RAM shares for the Route53 resolver rules that allow us to resolve DNS queries in the CDM environment."
}

output "cdm_customer_gateway" {
  value       = aws_customer_gateway.cdm
  description = "The gateway for the site-to-site VPN connection to CDM."
}

output "cdm_security_group" {
  value       = aws_security_group.cdm
  description = "A security group that allows for all necessary communications between the CDM agents and the CDM CIDRs."
}

output "cdm_tgw_route_table" {
  value       = aws_ec2_transit_gateway_route_table.cdm
  description = "The custom Transit Gateway route table for the CDM VPN connection."
}

output "cdm_tgw_route_table_association" {
  value       = aws_ec2_transit_gateway_route_table_association.cdm
  description = "The association between the CDM VPN connection and its custom Transit Gateway route table."
}

output "cdm_vpn_connection" {
  value       = aws_vpn_connection.cdm
  description = "The site-to-site VPN connection to CDM."
}
