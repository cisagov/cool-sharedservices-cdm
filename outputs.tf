output "cdm_cloudtrail_access_policy" {
  value       = module.cdm_cloudtrail.access_policy
  description = "The IAM policy with the necessary permissions to access the CDM CloudTrail data."
}

output "cdm_cloudtrail_access_role" {
  value       = module.cdm_cloudtrail.access_role
  description = "The IAM role that can be assumed to access the CDM CloudTrail data."
}

output "cdm_cloudtrail_assume_access_role_policy" {
  value       = module.cdm_cloudtrail.assume_access_role_policy
  description = "The IAM policy that allows the CDM user to assume the IAM role that allows access the CDM CloudTrail data."
}

output "cdm_cloudtrail_bucket" {
  value       = module.cdm_cloudtrail.bucket
  description = "The S3 bucket where CloudTrail logs are stored for CDM."
}

output "cdm_cloudtrail_deadletter_queue" {
  value       = module.cdm_cloudtrail.deadletter_queue
  description = "The SQS deadletter queue of messages notifying of CloudTrail logs being written to the CDM S3 bucket for which processing has failed."
}

output "cdm_cloudtrail_queue" {
  value       = module.cdm_cloudtrail.queue
  description = "The SQS queue of messages notifying of CloudTrail logs being written to the CDM S3 bucket."
}

output "cdm_cloudtrail_topic" {
  value       = module.cdm_cloudtrail.topic
  description = "The SNS topic for notifications of CloudTrail logs being written to the CDM S3 bucket."
}

output "cdm_cloudtrail_trail" {
  value       = module.cdm_cloudtrail.trail
  description = "The CloudTrail trail for CDM."
}

output "cdm_cloudwatch_access_policy" {
  value       = aws_iam_policy.cloudwatch
  description = "The IAM policy with the necessary permissions to access the CDM CloudWatch data."
}

output "cdm_cloudwatch_logs_bucket" {
  value       = aws_s3_bucket.cloudwatch
  description = "The S3 bucket where CloudWatch logs are stored for CDM."
}

output "cdm_cloudwatch_logs_sns_topic" {
  value       = aws_sns_topic.cloudwatch_logs
  description = "The SNS topic that receives notifications from the CDM S3 bucket and is subscribed to by the SQS queue."
}

output "cdm_cloudwatch_logs_sqs_queue" {
  value       = aws_sqs_queue.cloudwatch_logs
  description = "The SQS queue that receives CloudWatch log events when objects are added to the CDM S3 bucket."
}

output "cdm_cloudwatch_logs_sqs_dead_letter_queue" {
  value       = aws_sqs_queue.cloudwatch_logs_dead_letter
  description = "The SQS dead letter queue that receives events that could not be delivered to the main queue."
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

output "cdm_vpc_dhcp_options" {
  value       = aws_vpc_dhcp_options.cdm
  description = "The Shared Services VPC DHCP options.  These are identical to the DHCP options created in cisagov/cool-sharedservices-networking, except that we add the main CDM domain (var.cdm_domains[0]) to the DNS search path."
}

output "cdm_vpc_dhcp_options_association" {
  value       = aws_vpc_dhcp_options_association.cdm
  description = "The association between the Shared Services VPC and the CDM-enhanced DHCP options."
}

output "cdm_vpn_connection" {
  value       = aws_vpn_connection.cdm
  description = "The site-to-site VPN connection to CDM."
  sensitive   = true
}

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
