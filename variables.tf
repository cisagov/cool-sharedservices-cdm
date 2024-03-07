# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "cdm_cloudwatch_bucket_name" {
  description = "The name of the S3 bucket that will receive logs from CloudWatch so that they can later be ingested by CDM (e.g. \"cdm-cloudwatch-logs\")."
  type        = string
}

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

variable "cloudwatch_logs_sqs_queue_name" {
  default     = "cdm-cloudwatch-logs"
  description = "The name of the SQS queue that will receive CloudWatch log events when objects are added to the CDM S3 bucket (e.g. \"cdm-cloudwatch-logs\")."
  type        = string
}

variable "cloudwatch_logs_sns_topic_name" {
  default     = "cdm-cloudwatch-logs"
  description = "The name of the SNS topic that will receive notifications from the CDM S3 bucket when objects are added to it (e.g. \"cdm-cloudwatch-logs\")."
  type        = string
}

variable "cloudwatch_policy_description" {
  type        = string
  description = "The description to associate with the IAM policy that allows read access to the specific CloudWatch log streams in which CDM is interested."
  default     = "Allows read access to the specific CloudWatch log streams in which CDM is interested."
}

variable "cloudwatch_policy_instances" {
  type        = list(string)
  description = "Each string corresponds to the name of an instance, which itself corresponds to a CloudWatch log stream to which CDM is to be allowed read access.  (The name of the instance should be as it appears in the CloudWatch log stream; in some cases this is the FQDN and in others it is just the hostname.)  The selected CloudWatch log groups in which these streams reside are defined by the variable cloudwatch_policy_log_groups."
  default     = []
}

variable "cloudwatch_policy_log_groups" {
  type        = list(string)
  description = "Each string corresponds to the name of a CloudWatch log group for which CDM is to be allowed read access for selected CloudWatch log streams.  The selected CloudWatch log streams inside these log groups to which CDM is to be allowed access are defined by the variable cloudwatch_policy_log_streams."
  default     = []
}

variable "cloudwatch_policy_name" {
  type        = string
  description = "The name to assign the IAM policy that allows read access to the specific CloudWatch log streams in which CDM is interested."
  default     = "CdmCloudWatchReadOnly"
}

variable "cloudwatch_to_firehose_role_description" {
  default     = "The IAM policy/role that allows CloudWatch to deliver CDM log events to the Firehose delivery stream that will send them to an S3 bucket for ingestion into CDM."
  description = "The description to associate with the IAM policy and role that allows CloudWatch to deliver CDM log events to the Firehose delivery stream that will send them to an S3 bucket for ingestion into CDM."
  type        = string
}

variable "cloudwatch_to_firehose_role_name" {
  default     = "CdmCloudWatchLogsToFirehose"
  description = "The name to assign the IAM policy and role that allow CloudWatch to deliver CDM log events to the Firehose delivery stream that will send them to an S3 bucket for ingestion into CDM."
  type        = string
}

variable "firehose_delivery_stream_name" {
  default     = "cdm-cloudwatch-logs"
  description = "The name to assign the Firehose delivery stream that will receive the CloudWatch log events and send them to the CDM S3 bucket."
  type        = string
}

variable "firehose_to_s3_role_description" {
  default     = "The IAM policy/role that allows Firehose to deliver CDM log events to the S3 bucket where they will be ingested into CDM."
  description = "The description to associate with the IAM policy and role that allows Firehose to deliver CDM log events to the S3 bucket where they will be ingested into CDM."
  type        = string
}

variable "firehose_to_s3_role_name" {
  default     = "CdmFirehoseToS3"
  description = "The name to assign the IAM policy and role that allow Firehose to deliver CDM log events to the S3 bucket where they will be ingested into CDM."
  type        = string
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
