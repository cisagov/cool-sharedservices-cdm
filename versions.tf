terraform {
  # We want to hold off on 0.14 or higher until we have tested it.
  required_version = "~> 0.13.0"

  # If you use any other providers you should also pin them to the
  # major version currently being used.  This practice will help us
  # avoid unwelcome surprises.
  required_providers {
    # Version 3.43.0 of the Terraform AWS provider is the first
    # version that correctly allows the local_ipv4_network_cidr
    # and remote_ipv4_network_cidr keys of the aws_vpn_connection
    # resource to be non-/32 CIDRs.
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.43"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}
