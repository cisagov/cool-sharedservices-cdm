# ------------------------------------------------------------------------------
# Provision the SNS topic that will receive notifications from the CDM S3
# bucket and be subscribed to by the SQS queue.
# ------------------------------------------------------------------------------

# Create an SNS topic to receive notifications from the S3 bucket.
# NOTE: Using an SNS topic is a requirement for the tool used by CDM.
# See https://docs.splunk.com/Documentation/AddOns/released/AWS/SQS-basedS3
# ("AWS service configuration prerequisites" and "Best practices" sections) for
# more information.
resource "aws_sns_topic" "cloudwatch_logs" {
  provider = aws.sharedservicesprovisionaccount

  name = var.cloudwatch_logs_sns_topic_name
}

# Create an IAM policy document that allows the CDM S3 bucket to send
# notifications to the SNS topic.
data "aws_iam_policy_document" "s3_to_sns" {
  statement {
    actions = [
      "SNS:Publish",
    ]

    condition {
      test     = "ArnLike"
      values   = [aws_s3_bucket.cloudwatch.arn]
      variable = "aws:SourceArn"
    }

    effect = "Allow"

    principals {
      identifiers = ["s3.amazonaws.com"]
      type        = "Service"
    }

    resources = [
      aws_sns_topic.cloudwatch_logs.arn,
    ]
  }
}

# Attach the policy (that allows the CDM S3 bucket to send notifications to the
# SNS topic) to the SNS topic.
resource "aws_sns_topic_policy" "cloudwatch_logs" {
  provider = aws.sharedservicesprovisionaccount

  arn    = aws_sns_topic.cloudwatch_logs.arn
  policy = data.aws_iam_policy_document.s3_to_sns.json
}
