# ------------------------------------------------------------------------------
# Provision the IAM resources that will allow Firehose to send log events to the
# CDM S3 bucket.
# ------------------------------------------------------------------------------

# Create an IAM policy document that allows Firehose to assume the role that
# this policy is attached to.
data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    effect = "Allow"

    principals {
      identifiers = ["firehose.amazonaws.com"]
      type        = "Service"
    }
  }
}

# Create the IAM role that Firehose will assume to deliver Cloudwatch log events
# to the CDM S3 bucket.
resource "aws_iam_role" "firehose_to_s3" {
  provider = aws.sharedservicesprovisionaccount

  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
  description        = var.firehose_to_s3_role_description
  name               = var.firehose_to_s3_role_name
}

# Create an IAM policy document that allows Firehose to write to the CDM S3
# bucket.
data "aws_iam_policy_document" "firehose_to_s3" {
  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    effect = "Allow"

    resources = [
      aws_s3_bucket.cloudwatch.arn,
      "${aws_s3_bucket.cloudwatch.arn}/*",
    ]
  }
}

# Create the policy that allows CloudWatch to write to the Firehose delivery
# stream to the role that CloudWatch will assume in order to accomplish that.
resource "aws_iam_policy" "firehose_to_s3" {
  provider = aws.sharedservicesprovisionaccount

  description = var.firehose_to_s3_role_description
  name        = var.firehose_to_s3_role_name
  policy      = data.aws_iam_policy_document.firehose_to_s3.json
}

# Attach the policy that allows Firehose to write to the CDM S3 bucket to the
# role that Firehose will assume in order to accomplish that.
resource "aws_iam_role_policy_attachment" "firehose_to_s3" {
  provider = aws.sharedservicesprovisionaccount

  policy_arn = aws_iam_policy.firehose_to_s3.arn
  role       = aws_iam_role.firehose_to_s3.name
}
