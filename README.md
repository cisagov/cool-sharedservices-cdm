# cool-sharedservices-cdm #

[![GitHub Build Status](https://github.com/cisagov/cool-sharedservices-cdm/workflows/build/badge.svg)](https://github.com/cisagov/cool-sharedservices-cdm/actions)

This is a Terraform deployment for creating the site-to-site VPN tunnel between
the COOL and the CDM (Continuous Diagnostics and Mitigation) environment in the
COOL Shared Services account.  It also creates:

- The resources necessary to stream the COOL Shared Services CloudWatch logs
  into an S3 bucket where they can be imported into the CDM environment
- An IAM user and role that allows access to the CloudTrail logs in the COOL
  Shared Services account and the S3 bucket where the CloudWatch logs are stored

This deployment should be applied immediately after
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

<!-- BEGIN_TF_DOCS -->
## Requirements ##

| Name | Version |
|------|---------|
| terraform | ~> 1.1 |
| aws | ~> 6.7 |

## Providers ##

| Name | Version |
|------|---------|
| aws | ~> 6.7 |
| aws.sharedservicesprovisionaccount | ~> 6.7 |
| terraform | n/a |

## Modules ##

| Name | Source | Version |
|------|--------|---------|
| cdm\_cloudtrail | github.com/cisagov/cool-cdm-cloudtrail-tf-module | n/a |

## Resources ##

| Name | Type |
|------|------|
| [aws_cloudwatch_log_subscription_filter.cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_iam_policy.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.cloudwatch_to_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.firehose_to_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.provisioncdm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cloudwatch_to_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.firehose_to_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cloudwatch_to_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.firehose_to_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.provisioncdm_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kinesis_firehose_delivery_stream.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [aws_s3_bucket.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_ownership_controls.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_security_group.cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cdm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_sns_topic.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sqs_queue.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.cloudwatch_logs_dead_letter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_sqs_queue_policy.cloudwatch_logs_dead_letter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.sharedservices](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.allow_access_to_selected_cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudwatch_to_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.firehose_to_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.provisioncdm_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_to_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_to_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sns_to_sqs_dead_letter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [terraform_remote_state.master](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.sharedservices](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.users](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | The AWS region where the Shared Services account resides (e.g. "us-east-1"). | `string` | `"us-east-1"` | no |
| cdm\_cloudtrail\_assume\_role\_policy\_description | The description to associate with the IAM policy that allows the CDM user to assume the IAM role that allows access to the CDM CloudTrail data (e.g., "The IAM policy that allows the CDM user to assume the IAM role that allows access to the CDM CloudTrail data in the AccountName account."). | `string` | n/a | yes |
| cdm\_cloudtrail\_assume\_role\_policy\_name | The name to associate with the IAM policy that allows the CDM user to assume the IAM role that allows access to the CDM CloudTrail data (e.g., "ACCTNAME-AssumeCdmCloudTrail"). | `string` | n/a | yes |
| cdm\_cloudwatch\_bucket\_name | The name of the S3 bucket that will receive logs from CloudWatch so that they can later be ingested by CDM (e.g. "cdm-cloudwatch-logs"). | `string` | n/a | yes |
| cdm\_user\_name | The user name of the CDM user who will assume the role to access the CloudTrail data. | `string` | n/a | yes |
| cloudwatch\_logs\_sns\_topic\_name | The name of the SNS topic that will receive notifications from the CDM S3 bucket when objects are added to it (e.g. "cdm-cloudwatch-logs"). | `string` | `"cdm-cloudwatch-logs"` | no |
| cloudwatch\_logs\_sqs\_queue\_name | The name of the SQS queue that will receive CloudWatch log events when objects are added to the CDM S3 bucket (e.g. "cdm-cloudwatch-logs").  Note that this name will be appended with "-dead-letter" to create the name of the SQS dead-letter queue that receives events that could not be delivered to the main queue. | `string` | `"cdm-cloudwatch-logs"` | no |
| cloudwatch\_policy\_description | The description to associate with the IAM policy that allows read access to the specific CloudWatch log streams in which CDM is interested. | `string` | `"Allows read access to the specific CloudWatch log streams in which CDM is interested."` | no |
| cloudwatch\_policy\_instances | Each string corresponds to the name of an instance, which itself corresponds to a CloudWatch log stream to which CDM is to be allowed read access.  (The name of the instance should be as it appears in the CloudWatch log stream; in some cases this is the FQDN and in others it is just the hostname.)  The selected CloudWatch log groups in which these streams reside are defined by the variable cloudwatch\_policy\_log\_groups. | `list(string)` | `[]` | no |
| cloudwatch\_policy\_log\_groups | Each string corresponds to the name of a CloudWatch log group for which CDM is to be allowed read access for selected CloudWatch log streams.  The selected CloudWatch log streams inside these log groups to which CDM is to be allowed access are defined by the variable cloudwatch\_policy\_log\_streams. | `list(string)` | `[]` | no |
| cloudwatch\_policy\_name | The name to assign the IAM policy that allows read access to the specific CloudWatch log streams in which CDM is interested. | `string` | `"CdmCloudWatchReadOnly"` | no |
| cloudwatch\_to\_firehose\_role\_description | The description to associate with the IAM policy and role that allows CloudWatch to deliver CDM log events to the Firehose delivery stream that will send them to an S3 bucket for ingestion into CDM. | `string` | `"The IAM policy/role that allows CloudWatch to deliver CDM log events to the Firehose delivery stream that will send them to an S3 bucket for ingestion into CDM."` | no |
| cloudwatch\_to\_firehose\_role\_name | The name to assign the IAM policy and role that allow CloudWatch to deliver CDM log events to the Firehose delivery stream that will send them to an S3 bucket for ingestion into CDM. | `string` | `"CdmCloudWatchLogsToFirehose"` | no |
| firehose\_delivery\_stream\_name | The name to assign the Firehose delivery stream that will receive the CloudWatch log events and send them to the CDM S3 bucket. | `string` | `"cdm-cloudwatch-logs"` | no |
| firehose\_to\_s3\_role\_description | The description to associate with the IAM policy and role that allows Firehose to deliver CDM log events to the S3 bucket where they will be ingested into CDM. | `string` | `"The IAM policy/role that allows Firehose to deliver CDM log events to the S3 bucket where they will be ingested into CDM."` | no |
| firehose\_to\_s3\_role\_name | The name to assign the IAM policy and role that allow Firehose to deliver CDM log events to the S3 bucket where they will be ingested into CDM. | `string` | `"CdmFirehoseToS3"` | no |
| provisionaccount\_role\_name | The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account. | `string` | `"ProvisionAccount"` | no |
| provisioncdm\_policy\_description | The description to associate with the IAM policy that allows provisioning of the CDM layer in the Shared Services account. | `string` | `"Allows provisioning of the CDM layer in the Shared Services account."` | no |
| provisioncdm\_policy\_name | The name to assign the IAM policy that allows provisioning of the CDM layer in the Shared Services account. | `string` | `"ProvisionCdm"` | no |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |
| terraform\_state\_bucket | The name of the S3 bucket where Terraform state is stored. | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| cdm\_cloudtrail\_access\_policy | The IAM policy with the necessary permissions to access the CDM CloudTrail data. |
| cdm\_cloudtrail\_access\_role | The IAM role that can be assumed to access the CDM CloudTrail data. |
| cdm\_cloudtrail\_assume\_access\_role\_policy | The IAM policy that allows the CDM user to assume the IAM role that allows access the CDM CloudTrail data. |
| cdm\_cloudtrail\_bucket | The S3 bucket where CloudTrail logs are stored for CDM. |
| cdm\_cloudtrail\_deadletter\_queue | The SQS deadletter queue of messages notifying of CloudTrail logs being written to the CDM S3 bucket for which processing has failed. |
| cdm\_cloudtrail\_queue | The SQS queue of messages notifying of CloudTrail logs being written to the CDM S3 bucket. |
| cdm\_cloudtrail\_topic | The SNS topic for notifications of CloudTrail logs being written to the CDM S3 bucket. |
| cdm\_cloudtrail\_trail | The CloudTrail trail for CDM. |
| cdm\_cloudwatch\_access\_policy | The IAM policy with the necessary permissions to access the CDM CloudWatch data. |
| cdm\_cloudwatch\_logs\_bucket | The S3 bucket where CloudWatch logs are stored for CDM. |
| cdm\_cloudwatch\_logs\_sns\_topic | The SNS topic that receives notifications from the CDM S3 bucket and is subscribed to by the SQS queue. |
| cdm\_cloudwatch\_logs\_sqs\_dead\_letter\_queue | The SQS dead letter queue that receives events that could not be delivered to the main queue. |
| cdm\_cloudwatch\_logs\_sqs\_queue | The SQS queue that receives CloudWatch log events when objects are added to the CDM S3 bucket. |
| cdm\_security\_group | A security group that allows for all necessary communications between the CDM agents and the CDM CIDRs. |
<!-- END_TF_DOCS -->

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
