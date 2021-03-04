# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "venom_cidr" {
  type        = string
  description = "The CIDR block on the VENOM end of the site-to-site VPN tunnel (e.g. \"10.201.0.0/16\")."
}

variable "venom_dns_ips" {
  type        = list(string)
  description = "The DNS server IPs for the VENOM environment (e.g. [\"100.200.75.25\", \"100.200.100.50\"])."
}

variable "venom_domains" {
  type        = list(string)
  description = "The domains for the VENOM environment (e.g. [\"thulsa.example.com\", \"doom.example.com\", \"222.111.10.in-addr.arpa\"])."
}

variable "venom_tunnel_ip" {
  type        = string
  description = "The IP address of the site-to-site VPN tunnel endpoint on the VENOM side (e.g. \"100.200.75.25\")."
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

variable "provisionaccount_role_name" {
  type        = string
  description = "The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account."
  default     = "ProvisionAccount"
}

variable "provisionvenom_policy_description" {
  type        = string
  description = "The description to associate with the IAM policy that allows provisioning of the VENOM layer in the Shared Services account."
  default     = "Allows provisioning of the VENOM layer in the Shared Services account."
}

variable "provisionvenom_policy_name" {
  type        = string
  description = "The name to assign the IAM policy that allows provisioning of the VENOM layer in the Shared Services account."
  default     = "ProvisionVenom"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created."
  default     = {}
}
