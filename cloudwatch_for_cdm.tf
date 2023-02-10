# ------------------------------------------------------------------------------
# Provision the IAM policy that allows access to the CDM CloudWatch data
# and attach it to the existing IAM role that the CDM user can already
# assume to access the CDM CloudTrail data.
# ------------------------------------------------------------------------------

# Policy document that assigns the necessary permissions to access the
# CDM CloudWatch data.
data "aws_iam_policy_document" "allow_access_to_selected_cloudwatch_logs" {
  statement {
    actions = [
      "logs:GetLogEvents",
    ]
    effect = "Allow"
    resources = [
      # setproduct() allows us to iterate through every possible pair
      # where one member is selected from local.cdm_instances and the
      # other is selected from local.cdm_log_streams.
      for instance_and_stream in setproduct(local.cdm_instances, local.cdm_log_streams) :
      format("arn:aws:logs:%s:%d:log-group:/instance-logs/%s:log-stream:%s", var.aws_region, local.sharedservices_account_id, instance_and_stream[0], instance_and_stream[1])
    ]
  }
}

# Policy with the necessary permissions to access the CDM CloudWatch
# data.
resource "aws_iam_policy" "cloudwatch" {
  provider = aws.sharedservicesprovisionaccount

  description = var.cloudwatch_policy_description
  name        = var.cloudwatch_policy_name
  policy      = data.aws_iam_policy_document.allow_access_to_selected_cloudwatch_logs.json
}

# Attach the policy to the role that already exists
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  provider = aws.sharedservicesprovisionaccount

  policy_arn = aws_iam_policy.cloudwatch.arn
  role       = module.cdm_cloudtrail.access_role.name
}
