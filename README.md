# cool-sharedservices-cdm #

[![GitHub Build Status](https://github.com/cisagov/cool-sharedservices-cdm/workflows/build/badge.svg)](https://github.com/cisagov/cool-sharedservices-cdm/actions)

This is a Terraform deployment for creating the site-to-site VPN
tunnel between the COOL and the CDM (Continuous Diagnostics and
Mitigation) environment in the COOL Shared Services account.  This
deployment should be applied immediately after
[cisagov/cool-sharedservices-networking](https://github.com/cisagov/cool-sharedservices-networking),
and before
[cisagov/cool-sharedservices-freeipa](https://github.com/cisagov/cool-sharedservices-freeipa)
or
[cisagov/cool-sharedservices-openvpn](https://github.com/cisagov/cool-sharedservices-openvpn).

## Pre-requisites ##

- [Terraform](https://www.terraform.io/) installed on your system.
- An accessible AWS S3 bucket to store Terraform state
  (specified in [backend.tf](backend.tf)).
- An accessible AWS DynamoDB database to store the Terraform state lock
  (specified in [backend.tf](backend.tf)).
- Access to all of the Terraform remote states specified in
  [remote_states.tf](remote_states.tf).

## Requirements ##

| Name | Version |
|------|---------|
| terraform | ~> 0.13.0 |
| aws | ~> 3.43 |
| null | ~> 3.0 |

## Providers ##

| Name | Version |
|------|---------|
| aws | ~> 3.43 |
| aws.organizationsreadonly | ~> 3.43 |
| aws.sharedservicesprovisionaccount | ~> 3.43 |
| null | ~> 3.0 |
| terraform | n/a |

## Modules ##

| Name | Source | Version |
|------|--------|---------|
| cdm\_cloudtrail | github.com/cisagov/cool-cdm-cloudtrail-tf-module | n/a |

## Resources ##

| Name | Type |
|------|------|
| [aws_customer_gateway.cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | resource |
| [aws_ec2_transit_gateway_route.cdm_sharedservices](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.cdm_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route.sharedservices_vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table.cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table_association.cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_iam_policy.provisioncdm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.provisioncdm_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_ram_resource_share.to_cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_route53_resolver_endpoint.from_cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_route53_resolver_endpoint.to_cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_route53_resolver_rule.to_cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule) | resource |
| [aws_route53_resolver_rule_association.to_cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_security_group.cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.dns_from_cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.dns_to_cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.dns_from_cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.dns_to_cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_vpc_dhcp_options.cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_vpn_connection.cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [null_resource.break_association_with_default_route_table](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.sharedservices](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.provisioncdm_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.cool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [terraform_remote_state.master](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.sharedservices](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.users](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | The AWS region where the Shared Services account resides (e.g. "us-east-1"). | `string` | `"us-east-1"` | no |
| cdm\_cidr | The CIDR block on the CDM end of the site-to-site VPN tunnel (e.g. "10.201.0.0/16"). | `string` | n/a | yes |
| cdm\_cloudtrail\_assume\_role\_policy\_description | The description to associate with the IAM policy that allows the CDM user to assume the IAM role that allows access to the CDM CloudTrail data (e.g., "The IAM policy that allows the CDM user to assume the IAM role that allows access to the CDM CloudTrail data in the AccountName account."). | `string` | n/a | yes |
| cdm\_cloudtrail\_assume\_role\_policy\_name | The name to associate with the IAM policy that allows the CDM user to assume the IAM role that allows access to the CDM CloudTrail data (e.g., "ACCTNAME-AssumeCdmCloudTrail"). | `string` | n/a | yes |
| cdm\_dns\_ips | The DNS server IPs for the CDM environment (e.g. ["100.200.75.25", "100.200.100.50"]). | `list(string)` | n/a | yes |
| cdm\_domains | The domains for the CDM environment (e.g. ["thulsa.example.com", "doom.example.com", "222.111.10.in-addr.arpa"]).  The first domain listed should be the main CDM domain, as it will be used as an additional search domain for DNS lookups. | `list(string)` | n/a | yes |
| cdm\_tunnel\_ip | The IP address of the site-to-site VPN tunnel endpoint on the CDM side (e.g. "100.200.75.25"). | `string` | n/a | yes |
| cdm\_user\_name | The user name of the CDM user who will assume the role to access the CloudTrail data. | `string` | n/a | yes |
| cdm\_vpn\_preshared\_key | The pre-shared key to use for setting up the site-to-site VPN connection between the COOL and CDM.  This must be a string of 36 characters, which can include alphanumerics, periods, and underscores (e.g. "abcdefghijklmnopqrstuvwxyz01234567.\_"). | `string` | n/a | yes |
| provisionaccount\_role\_name | The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account. | `string` | `"ProvisionAccount"` | no |
| provisioncdm\_policy\_description | The description to associate with the IAM policy that allows provisioning of the CDM layer in the Shared Services account. | `string` | `"Allows provisioning of the CDM layer in the Shared Services account."` | no |
| provisioncdm\_policy\_name | The name to assign the IAM policy that allows provisioning of the CDM layer in the Shared Services account. | `string` | `"ProvisionCdm"` | no |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |

## Outputs ##

| Name | Description |
|------|-------------|
| cdm\_cloudtrail\_access\_policy | The IAM policy with the necessary permissions to access the CDM CloudTrail data. |
| cdm\_cloudtrail\_access\_role | The IAM role that can be assumed to access the CDM CloudTrail data. |
| cdm\_cloudtrail\_assume\_access\_role\_policy | The IAM policy that allows the CDM user to assume the IAM role that allows access the CDM CloudTrail data. |
| cdm\_cloudtrail\_bucket | The S3 bucket where CloudTrail logs are stored for CDM. |
| cdm\_cloudtrail\_deadletter\_queue | The SQS deadletter queue of messages notifying of CloudTrail logs being written to the CDM S3 bucket for which processing has failed. |
| cdm\_cloudtrail\_queue | The SQS queue of messages notifying of CloudTrail logs being written to the CDM S3 bucket. |
| cdm\_cloudtrail\_topic | The SNS topic for notifications of CloudTrail logs being written to the CDM S3 bucket. |
| cdm\_cloudtrail\_trail | The CloudTrail trail for CDM. |
| cdm\_customer\_gateway | The gateway for the site-to-site VPN connection to CDM. |
| cdm\_security\_group | A security group that allows for all necessary communications between the CDM agents and the CDM CIDRs. |
| cdm\_tgw\_route\_table | The custom Transit Gateway route table for the CDM VPN connection. |
| cdm\_tgw\_route\_table\_association | The association between the CDM VPN connection and its custom Transit Gateway route table. |
| cdm\_vpc\_dhcp\_options | The Shared Services VPC DHCP options.  These are identical to the DHCP options created in cisagov/cool-sharedservices-networking, except that we add the main CDM domain (var.cdm\_domains[0]) to the DNS search path. |
| cdm\_vpc\_dhcp\_options\_association | The association between the Shared Services VPC and the CDM-enhanced DHCP options. |
| cdm\_vpn\_connection | The site-to-site VPN connection to CDM. |
| dns\_from\_cdm\_security\_group | The security group that allows DNS requests from the CDM environment. |
| dns\_to\_cdm\_security\_group | The security group that allows DNS requests to the CDM environment. |
| route53\_resolver\_endpoint\_from\_cdm | The Route53 resolver that allows the CDM environment to resolve DNS queries in our environment. |
| route53\_resolver\_endpoint\_to\_cdm | The Route53 resolver that allows us to resolve DNS queries in the CDM environment. |
| route53\_resolver\_rules\_to\_cdm | The Route53 resolver rules that allow us to resolve DNS queries in the CDM environment. |
| route53\_resolver\_rules\_to\_cdm\_ram\_shares | The RAM shares for the Route53 resolver rules that allow us to resolve DNS queries in the CDM environment. |

## Notes ##

Running `pre-commit` requires running `terraform init` in every
directory that contains Terraform code. In this repository, this is
only the main directory.

## Contributing ##

We welcome contributions!  Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
