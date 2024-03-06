# ------------------------------------------------------------------------------
# Provision resources to send CDM CloudWatch log events to a Firehose stream
# that will deliver them to the CDM S3 bucket, where they will be ingested into
# the CDM system.
# ------------------------------------------------------------------------------

# Create the Firehose delivery stream that will receive the CloudWatch log
# events and send them to the CDM S3 bucket.
resource "aws_kinesis_firehose_delivery_stream" "cloudwatch_logs" {
  provider = aws.sharedservicesprovisionaccount

  destination = "extended_s3"

  extended_s3_configuration {
    bucket_arn = aws_s3_bucket.cloudwatch.arn
    role_arn   = aws_iam_role.firehose_to_s3.arn
  }

  name = var.firehose_delivery_stream_name
}

# Create CloudWatch subscription filters to send events from CDM CloudWatch
# log groups to the Firehose delivery stream
resource "aws_cloudwatch_log_subscription_filter" "cdm" {
  provider = aws.sharedservicesprovisionaccount
  for_each = toset(var.cloudwatch_policy_log_groups)

  destination_arn = aws_kinesis_firehose_delivery_stream.cloudwatch_logs.arn
  filter_pattern  = ""
  log_group_name  = each.key
  name            = each.key
  role_arn        = aws_iam_role.cloudwatch_to_firehose.arn
}
