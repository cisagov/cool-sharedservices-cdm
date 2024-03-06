# ------------------------------------------------------------------------------
# Provision the SQS queues that will receive notifications from the CDM SNS
# topic.
# ------------------------------------------------------------------------------

# Create a "dead letter" SQS queue that will receive events that could not be
# delivered to the main queue.
resource "aws_sqs_queue" "cloudwatch_logs_dead_letter" {
  provider = aws.sharedservicesprovisionaccount

  name = "${var.cloudwatch_logs_sqs_queue_name}-dead-letter"
}

# Create an IAM policy document that allows the SNS topic to send messages to
# the SQS dead letter queue.
data "aws_iam_policy_document" "sns_to_sqs_dead_letter" {
  statement {
    actions = [
      "sqs:SendMessage",
    ]

    condition {
      test     = "ArnEquals"
      values   = [aws_sns_topic.cloudwatch_logs.arn]
      variable = "aws:SourceArn"
    }

    effect = "Allow"

    principals {
      identifiers = ["sns.amazonaws.com"]
      type        = "Service"
    }

    resources = [
      aws_sqs_queue.cloudwatch_logs_dead_letter.arn,
    ]
  }
}

# Attach the policy (that allows the SNS topic to send messages to the SQS dead
# letter queue) to the SQS dead letter queue.
resource "aws_sqs_queue_policy" "cloudwatch_logs_dead_letter" {
  provider = aws.sharedservicesprovisionaccount

  policy    = data.aws_iam_policy_document.sns_to_sqs_dead_letter.json
  queue_url = aws_sqs_queue.cloudwatch_logs_dead_letter.id
}

# Create the SQS queue that will receive notifications from the SNS topic
# (triggered when objects are created in the CDM S3 bucket).
resource "aws_sqs_queue" "cloudwatch_logs" {
  provider = aws.sharedservicesprovisionaccount

  name = var.cloudwatch_logs_sqs_queue_name
  # Send messages to the dead letter queue after 3 failed attempts
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.cloudwatch_logs_dead_letter.arn,
    maxReceiveCount     = 3
  })
}

# Create an IAM policy document that allows the SNS topic to send messages to
# the SQS queue.
data "aws_iam_policy_document" "sns_to_sqs" {
  statement {
    actions = [
      "sqs:SendMessage",
    ]

    condition {
      test     = "ArnEquals"
      values   = [aws_sns_topic.cloudwatch_logs.arn]
      variable = "aws:SourceArn"
    }

    effect = "Allow"

    principals {
      identifiers = ["sns.amazonaws.com"]
      type        = "Service"
    }

    resources = [
      aws_sqs_queue.cloudwatch_logs.arn,
    ]
  }
}

# Attach the policy (that allows the SNS topic to send messages to the SQS
# queue) to the SQS queue.
resource "aws_sqs_queue_policy" "cloudwatch_logs" {
  provider = aws.sharedservicesprovisionaccount

  policy    = data.aws_iam_policy_document.sns_to_sqs.json
  queue_url = aws_sqs_queue.cloudwatch_logs.id
}

# Subscribe the SQS queue to the SNS topic.
resource "aws_sns_topic_subscription" "cloudwatch_logs" {
  provider = aws.sharedservicesprovisionaccount

  endpoint  = aws_sqs_queue.cloudwatch_logs.arn
  protocol  = "sqs"
  topic_arn = aws_sns_topic.cloudwatch_logs.arn
}
