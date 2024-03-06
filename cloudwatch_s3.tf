# ------------------------------------------------------------------------------
# Provision an S3 bucket to store CDM CloudWatch logs.
# ------------------------------------------------------------------------------

resource "aws_s3_bucket" "cloudwatch" {
  provider = aws.sharedservicesprovisionaccount

  bucket = var.cdm_cloudwatch_bucket_name
  tags = {
    "Name" = "CDM CloudWatch logs bucket"
  }
}

# Ensure the S3 bucket is encrypted
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudwatch" {
  provider = aws.sharedservicesprovisionaccount

  bucket = aws_s3_bucket.cloudwatch.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# This blocks ANY public access to the bucket or the objects it
# contains, even if misconfigured to allow public access.
resource "aws_s3_bucket_public_access_block" "cloudwatch" {
  provider = aws.sharedservicesprovisionaccount

  block_public_acls       = true
  block_public_policy     = true
  bucket                  = aws_s3_bucket.cloudwatch.id
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Any objects placed into this bucket should be owned by the bucket
# owner. This ensures that even if objects are added by a different
# account, the bucket-owning account retains full control over the
# objects stored in this bucket.
resource "aws_s3_bucket_ownership_controls" "cloudwatch" {
  provider = aws.sharedservicesprovisionaccount

  bucket = aws_s3_bucket.cloudwatch.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Configure the bucket to send notifications to the SNS topic whenever objects
# are added to the bucket.
resource "aws_s3_bucket_notification" "cloudwatch" {
  provider = aws.sharedservicesprovisionaccount

  bucket = aws_s3_bucket.cloudwatch.id

  topic {
    events    = ["s3:ObjectCreated:*"]
    topic_arn = aws_sns_topic.cloudwatch_logs.arn
  }
}
