# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "cdm_cidr" {
  type        = string
  description = "The CIDR block on the CDM end of the site-to-site VPN tunnel (e.g. \"10.201.0.0/16\")."
}

variable "cdm_cloudtrail_assume_role_policy_description" {
  type        = string
  description = "The description to associate with the IAM policy that allows the CDM user to assume the IAM role that allows access to the CDM CloudTrail data (e.g., \"The IAM policy that allows the CDM user to assume the IAM role that allows access to the CDM CloudTrail data in the AccountName account.\")."
}

variable "cdm_cloudtrail_assume_role_policy_name" {
  type        = string
  description = "The name to associate with the IAM policy that allows the CDM user to assume the IAM role that allows access to the CDM CloudTrail data (e.g., \"ACCTNAME-AssumeCdmCloudTrail\")."
}

variable "cdm_dns_ips" {
  type        = list(string)
  description = "The DNS server IPs for the CDM environment (e.g. [\"100.200.75.25\", \"100.200.100.50\"])."
}

variable "cdm_domains" {
  type        = list(string)
  description = "The domains for the CDM environment (e.g. [\"thulsa.example.com\", \"doom.example.com\", \"222.111.10.in-addr.arpa\"]).  The first domain listed should be the main CDM domain, as it will be used as an additional search domain for DNS lookups."
}

variable "cdm_tunnel_ip" {
  type        = string
  description = "The IP address of the site-to-site VPN tunnel endpoint on the CDM side (e.g. \"100.200.75.25\")."
}

variable "cdm_user_name" {
  type        = string
  description = "The user name of the CDM user who will assume the role to access the CloudTrail data."
}

variable "cdm_vpn_preshared_key" {
  type        = string
  description = "The pre-shared key to use for setting up the site-to-site VPN connection between the COOL and CDM.  This must be a string of 36 characters, which can include alphanumerics, periods, and underscores (e.g. \"abcdefghijklmnopqrstuvwxyz01234567._\")."
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

variable "cloudwatch_policy_description" {
  type        = string
  description = "The description to associate with the IAM policy that allows read access to the specific CloudWatch log streams in which CDM is interested."
  default     = "Allows read access to the specific CloudWatch log streams in which CDM is interested."
}

variable "cloudwatch_policy_instances" {
  type        = list(string)
  description = "Each string corresponds to the name of an instance (as it appears in the CloudWatch log group) for which CDM is to be allowed read access to the specific CloudWatch log groups in which they are interested."
  default     = []
}

variable "cloudwatch_policy_log_groups" {
  type        = list(string)
  description = "Each string corresponds to the name of a CloudWatch log group for which CDM is to be allowed read access for selected CLoudWatch log streams."
  default     = []
}

variable "cloudwatch_policy_name" {
  type        = string
  description = "The name to assign the IAM policy that allows read access to the specific CloudWatch log streams in which CDM is interested."
  default     = "CdmCloudWatchReadOnly"
}

variable "provisionaccount_role_name" {
  type        = string
  description = "The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account."
  default     = "ProvisionAccount"
}

variable "provisioncdm_policy_description" {
  type        = string
  description = "The description to associate with the IAM policy that allows provisioning of the CDM layer in the Shared Services account."
  default     = "Allows provisioning of the CDM layer in the Shared Services account."
}

variable "provisioncdm_policy_name" {
  type        = string
  description = "The name to assign the IAM policy that allows provisioning of the CDM layer in the Shared Services account."
  default     = "ProvisionCdm"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created."
  default     = {}
}
