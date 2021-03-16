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
| terraform | ~> 0.12.0 |
| aws | ~> 3.0 |
| null | ~> 3.0 |

## Providers ##

| Name | Version |
|------|---------|
| aws | ~> 3.0 |
| aws.organizationsreadonly | ~> 3.0 |
| aws.sharedservicesprovisionaccount | ~> 3.0 |
| null | ~> 3.0 |
| terraform | n/a |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | The AWS region where the Shared Services account resides (e.g. "us-east-1"). | `string` | `us-east-1` | no |
| provisionaccount_role_name | The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account. | `string` | `ProvisionAccount` | no |
| provisioncdm_policy_description | The description to associate with the IAM policy that allows provisioning of the CDM layer in the Shared Services account. | `string` | `Allows provisioning of the CDM layer in the Shared Services account.` | no |
| provisioncdm_policy_name | The name to assign the IAM policy that allows provisioning of the CDM layer in the Shared Services account. | `string` | `ProvisionCdm` | no |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |
| cdm_cidr | The CIDR block on the CDM end of the site-to-site VPN tunnel (e.g. "10.201.0.0/16"). | `string` | n/a | yes |
| cdm_dns_ips | The DNS server IPs for the CDM environment (e.g. ["100.200.75.25", "100.200.100.50"]). | `list(string)` | n/a | yes |
| cdm_domains | The domains for the CDM environment (e.g. ["thulsa.example.com", "doom.example.com", "222.111.10.in-addr.arpa"]). | `list(string)` | n/a | yes |
| cdm_tunnel_ip | The IP address of the site-to-site VPN tunnel endpoint on the CDM side (e.g. "100.200.75.25"). | `string` | n/a | yes |
| cdm_vpn_preshared_key | The pre-shared key to use for setting up the site-to-site VPN connection between the COOL and CDM.  This must be a string of 36 characters, which can include alphanumerics, periods, and underscores (e.g. "abcdefghijklmnopqrstuvwxyz01234567._"). | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| dns_from_cdm_security_group | The security group that allows DNS requests from the CDM environment. |
| dns_to_cdm_security_group | The security group that allows DNS requests to the CDM environment. |
| route53_resolver_endpoint_from_cdm | The Route53 resolver that allows the CDM environment to resolve DNS queries in our environment. |
| route53_resolver_endpoint_to_cdm | The Route53 resolver that allows us to resolve DNS queries in the CDM environment. |
| route53_resolver_rules_to_cdm | The Route53 resolver rules that allow us to resolve DNS queries in the CDM environment. |
| route53_resolver_rules_to_cdm_ram_shares | The RAM shares for the Route53 resolver rules that allow us to resolve DNS queries in the CDM environment. |
| cdm_customer_gateway | The gateway for the site-to-site VPN connection to CDM. |
| cdm_security_group | A security group that allows for all necessary communications between the CDM agents and the CDM CIDRs. |
| cdm_tgw_route_table | The custom Transit Gateway route table for the CDM VPN connection. |
| cdm_tgw_route_table_association | The association between the CDM VPN connection and its custom Transit Gateway route table. |
| cdm_vpn_connection | The site-to-site VPN connection to CDM. |

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
