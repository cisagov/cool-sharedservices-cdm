# ------------------------------------------------------------------------------
# Retrieve the effective Account ID, User ID, and ARN in which
# Terraform is authorized.  This is used to calculate the session
# names for assumed roles.
# ------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

# ------------------------------------------------------------------------------
# Retrieve the caller identity for the Shared Services account
# provider in order to get the ID associated with the account.
# ------------------------------------------------------------------------------
data "aws_caller_identity" "sharedservices" {
  provider = aws.sharedservicesprovisionaccount
}

# ------------------------------------------------------------------------------
# Evaluate expressions for use throughout this configuration.
# ------------------------------------------------------------------------------
locals {
  # Extract the user name of the current caller for use
  # as assume role session names.
  caller_user_name = split("/", data.aws_caller_identity.current.arn)[1]

  # The ID of the Shared Services account
  sharedservices_account_id = data.aws_caller_identity.sharedservices.account_id

  #
  # Helpful lists for defining ACL and security group rules
  #

  # The ports the CDM agents use to communicate with the CDM
  # environment.
  cdm_ports = {
    crowdstrike_falcon_egress = {
      egress    = true
      from_port = 443
      proto     = "tcp"
      to_port   = 443
    },
    tenable_egress = {
      egress    = true
      from_port = 8834
      proto     = "tcp"
      to_port   = 8834
    },
    tenable_ingress = {
      egress    = false
      from_port = 8834
      proto     = "tcp"
      to_port   = 8834
    },
  }
}
