# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "venom_vpn_preshared_key" {
  type        = string
  description = "The pre-shared key to use for setting up the site-to-site VPN connection between the COOL and VENOM..  This must be a string of 36 characters, which can include alphanumerics, periods, and underscores (e.g. \"abcdefghijklmnopqrstuvwxyz0123456789\")."
}

# ------------------------------------------------------------------------------
# Optional parameters
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_region" {
  type        = string
  description = "The AWS region where the shared services account is to be created (e.g. \"us-east-1\")."
  default     = "us-east-1"
}

variable "provisionaccount_role_name" {
  type        = string
  description = "The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account."
  default     = "ProvisionAccount"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created."
  default     = {}
}
