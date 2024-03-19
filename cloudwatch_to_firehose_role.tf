# ------------------------------------------------------------------------------
# Provision the IAM resources that will allow CloudWatch to send log events to a
# Firehose delivery stream.
# ------------------------------------------------------------------------------

# Create an IAM policy document that allows CloudWatch to assume the role that
# this policy is attached to.
data "aws_iam_policy_document" "cloudwatch_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    effect = "Allow"

    principals {
      identifiers = ["logs.amazonaws.com"]
      type        = "Service"
    }
  }
}

# Create the IAM role that CloudWatch will assume to deliver log events to the
# Firehose delivery stream.
resource "aws_iam_role" "cloudwatch_to_firehose" {
  provider = aws.sharedservicesprovisionaccount

  assume_role_policy = data.aws_iam_policy_document.cloudwatch_assume_role.json
  description        = var.cloudwatch_to_firehose_role_description
  name               = var.cloudwatch_to_firehose_role_name
}

# Create an IAM policy document that allows CloudWatch to write to the Firehose
# delivery stream.
data "aws_iam_policy_document" "cloudwatch_to_firehose" {
  statement {
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:firehose:${var.aws_region}:${local.sharedservices_account_id}:deliverystream/${var.firehose_delivery_stream_name}",
    ]
  }
}

# Create the policy that allows CloudWatch to write to the Firehose delivery
# stream to the role that CloudWatch will assume in order to accomplish that.
resource "aws_iam_policy" "cloudwatch_to_firehose" {
  provider = aws.sharedservicesprovisionaccount

  description = var.cloudwatch_to_firehose_role_description
  name        = var.cloudwatch_to_firehose_role_name
  policy      = data.aws_iam_policy_document.cloudwatch_to_firehose.json
}

# Attach the policy that allows CloudWatch to write to the Firehose delivery
# stream to the role that CloudWatch will assume in order to accomplish that.
resource "aws_iam_role_policy_attachment" "cloudwatch_to_firehose" {
  provider = aws.sharedservicesprovisionaccount

  policy_arn = aws_iam_policy.cloudwatch_to_firehose.arn
  role       = aws_iam_role.cloudwatch_to_firehose.name
}
