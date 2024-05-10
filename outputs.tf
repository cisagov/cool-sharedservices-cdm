output "cdm_cloudtrail_access_policy" {
  description = "The IAM policy with the necessary permissions to access the CDM CloudTrail data."
  value       = module.cdm_cloudtrail.access_policy
}

output "cdm_cloudtrail_access_role" {
  description = "The IAM role that can be assumed to access the CDM CloudTrail data."
  value       = module.cdm_cloudtrail.access_role
}

output "cdm_cloudtrail_assume_access_role_policy" {
  description = "The IAM policy that allows the CDM user to assume the IAM role that allows access the CDM CloudTrail data."
  value       = module.cdm_cloudtrail.assume_access_role_policy
}

output "cdm_cloudtrail_bucket" {
  description = "The S3 bucket where CloudTrail logs are stored for CDM."
  value       = module.cdm_cloudtrail.bucket
}

output "cdm_cloudtrail_deadletter_queue" {
  description = "The SQS deadletter queue of messages notifying of CloudTrail logs being written to the CDM S3 bucket for which processing has failed."
  value       = module.cdm_cloudtrail.deadletter_queue
}

output "cdm_cloudtrail_queue" {
  description = "The SQS queue of messages notifying of CloudTrail logs being written to the CDM S3 bucket."
  value       = module.cdm_cloudtrail.queue
}

output "cdm_cloudtrail_topic" {
  description = "The SNS topic for notifications of CloudTrail logs being written to the CDM S3 bucket."
  value       = module.cdm_cloudtrail.topic
}

output "cdm_cloudtrail_trail" {
  description = "The CloudTrail trail for CDM."
  value       = module.cdm_cloudtrail.trail
}

output "cdm_cloudwatch_access_policy" {
  description = "The IAM policy with the necessary permissions to access the CDM CloudWatch data."
  value       = aws_iam_policy.cloudwatch
}

output "cdm_cloudwatch_logs_bucket" {
  description = "The S3 bucket where CloudWatch logs are stored for CDM."
  value       = aws_s3_bucket.cloudwatch
}

output "cdm_cloudwatch_logs_sns_topic" {
  description = "The SNS topic that receives notifications from the CDM S3 bucket and is subscribed to by the SQS queue."
  value       = aws_sns_topic.cloudwatch_logs
}

output "cdm_cloudwatch_logs_sqs_queue" {
  description = "The SQS queue that receives CloudWatch log events when objects are added to the CDM S3 bucket."
  value       = aws_sqs_queue.cloudwatch_logs
}

output "cdm_cloudwatch_logs_sqs_dead_letter_queue" {
  description = "The SQS dead letter queue that receives events that could not be delivered to the main queue."
  value       = aws_sqs_queue.cloudwatch_logs_dead_letter
}

output "cdm_customer_gateway" {
  description = "The gateway for the site-to-site VPN connection to CDM."
  value       = aws_customer_gateway.cdm
}

output "cdm_security_group" {
  description = "A security group that allows for all necessary communications between the CDM agents and the CDM CIDRs."
  value       = aws_security_group.cdm
}

output "cdm_tgw_route_table" {
  description = "The custom Transit Gateway route table for the CDM VPN connection."
  value       = aws_ec2_transit_gateway_route_table.cdm
}

output "cdm_tgw_route_table_association" {
  description = "The association between the CDM VPN connection and its custom Transit Gateway route table."
  value       = aws_ec2_transit_gateway_route_table_association.cdm
}

output "cdm_vpc_dhcp_options" {
  description = "The Shared Services VPC DHCP options.  These are identical to the DHCP options created in cisagov/cool-sharedservices-networking, except that we add the main CDM domain (var.cdm_domains[0]) to the DNS search path."
  value       = aws_vpc_dhcp_options.cdm
}

output "cdm_vpc_dhcp_options_association" {
  description = "The association between the Shared Services VPC and the CDM-enhanced DHCP options."
  value       = aws_vpc_dhcp_options_association.cdm
}

output "cdm_vpn_connection" {
  description = "The site-to-site VPN connection to CDM."
  sensitive   = true
  value       = aws_vpn_connection.cdm
}

output "dns_from_cdm_security_group" {
  description = "The security group that allows DNS requests from the CDM environment."
  value       = aws_security_group.dns_from_cdm
}

output "dns_to_cdm_security_group" {
  description = "The security group that allows DNS requests to the CDM environment."
  value       = aws_security_group.dns_to_cdm
}

output "route53_resolver_endpoint_from_cdm" {
  description = "The Route53 resolver that allows the CDM environment to resolve DNS queries in our environment."
  value       = aws_route53_resolver_endpoint.from_cdm
}

output "route53_resolver_endpoint_to_cdm" {
  description = "The Route53 resolver that allows us to resolve DNS queries in the CDM environment."
  value       = aws_route53_resolver_endpoint.to_cdm
}

output "route53_resolver_rules_to_cdm" {
  description = "The Route53 resolver rules that allow us to resolve DNS queries in the CDM environment."
  value       = aws_route53_resolver_rule.to_cdm
}

output "route53_resolver_rules_to_cdm_ram_shares" {
  description = "The RAM shares for the Route53 resolver rules that allow us to resolve DNS queries in the CDM environment."
  value       = aws_ram_resource_share.to_cdm
}
