# cool-sharedservices-venom #

[![GitHub Build Status](https://github.com/cisagov/cool-sharedservices-venom/workflows/build/badge.svg)](https://github.com/cisagov/cool-sharedservices-venom/actions)

This is a Terraform deployment for creating the site-to-site VPN
tunnel between the COOL and the VENOM (Virtual Enterprise
Network Operations Manager) environment in the COOL Shared
Services account.  This deployment should be laid down on top of
[cisagov/cool-sharedservices-networking](https://github.com/cisagov/cool-sharedservices-networking).

Note that this deployment does not need to attach an additional policy
to the provisioning role; all necessary permissions have already been
added by the policy attached in the
[cisagov/cool-sharedservices-networking](https://github.com/cisagov/cool-sharedservices-networking)
deployment.

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

## Providers ##

| Name | Version |
|------|---------|
| aws | ~> 3.0 |
| aws.sharedservicesprovisionaccount | ~> 3.0 |
| terraform | n/a |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | The AWS region where the Shared Services account resides (e.g. "us-east-1"). | `string` | `us-east-1` | no |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |
| venom_tunnel_ip | The IP address of the site-to-site VPN tunnel endpoint on the VENOM side (e.g. "100.200.75.25") | `string` | n/a | yes |
| venom_vpn_preshared_key | The pre-shared key to use for setting up the site-to-site VPN connection between the COOL and VENOM.  This must be a string of 36 characters, which can include alphanumerics, periods, and underscores (e.g. "abcdefghijklmnopqrstuvwxyz01234567._"). | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| venom_customer_gateway | The gateway for the site-to-site VPN connection to VENOM. |
| venom_vpn_connection | The site-to-site VPN connection to VENOM. |

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
