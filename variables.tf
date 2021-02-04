# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "venom_tunnel_ip" {
  type        = string
  description = "The IP address of the site-to-site VPN tunnel endpoint on the VENOM side (e.g. \"100.200.75.25\")"
}

variable "venom_vpn_preshared_key" {
  type        = string
  description = "The pre-shared key to use for setting up the site-to-site VPN connection between the COOL and VENOM.  This must be a string of 36 characters, which can include alphanumerics, periods, and underscores (e.g. \"abcdefghijklmnopqrstuvwxyz01234567._\")."
}

# ------------------------------------------------------------------------------
# Optional parameters
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_region" {
  type        = string
  description = "The AWS region where the Shared Services account resides (e.g. \"us-east-1\")."
  default     = "us-east-1"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created."
  default     = {}
}
