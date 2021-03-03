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
# Retrieve the information for all accounts in the organization.  This
# is used to lookup account IDs.
# ------------------------------------------------------------------------------
data "aws_organizations_organization" "cool" {
  provider = aws.organizationsreadonly
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

  # Look up the name of the Shared Services account from the AWS
  # organizations provider
  sharedservices_account_name = [
    for account in data.aws_organizations_organization.cool.accounts :
    account.name
    if account.id == local.sharedservices_account_id
  ][0]

  # Determine the Shared Services account type (staging or production)
  # based on the Shared Services account name.
  #
  # The account name format is "Shared Services (ACCOUNT_TYPE)" - for
  # example, "Shared Services (Production)".
  sharedservices_account_type = length(regexall("\\(([^()]*)\\)", local.sharedservices_account_name)) == 1 ? regex("\\(([^()]*)\\)", local.sharedservices_account_name)[0] : "Unknown"
  workspace_type              = lower(local.sharedservices_account_type)

  #
  # Helpful lists for defining ACL and security group rules
  #

  # The ports the VENOM agents use to communicate with the VENOM
  # environment.
  venom_ports = {
    ping_ingress = {
      egress    = false
      from_port = 8
      proto     = "icmp"
      to_port   = 0
    },
    ping_egress = {
      egress    = true
      from_port = 8
      proto     = "icmp"
      to_port   = 0
    },
    ping_reply_ingress = {
      egress    = false
      from_port = 0
      proto     = "icmp"
      to_port   = 0
    },
    ping_reply_egress = {
      egress    = true
      from_port = 0
      proto     = "icmp"
      to_port   = 0
    },
    tanium_ingress = {
      egress    = false
      from_port = 17472
      proto     = "tcp"
      to_port   = 17472
    },
    tanium_egress = {
      egress    = true
      from_port = 17472
      proto     = "tcp"
      to_port   = 17472
    },
    tanium_threat_response_ingress = {
      egress    = false
      from_port = 17475
      proto     = "tcp"
      to_port   = 17475
    },
    tanium_threat_response_egress = {
      egress    = true
      from_port = 17475
      proto     = "tcp"
      to_port   = 17475
    },
    tenable_ingress = {
      egress    = false
      from_port = 8834
      proto     = "tcp"
      to_port   = 8834
    },
    tenable_egress = {
      egress    = true
      from_port = 8834
      proto     = "tcp"
      to_port   = 8834
    },
  }

  # Useful when creating some security group or ACL rules
  tcp_and_udp = [
    "tcp",
    "udp",
  ]
}
