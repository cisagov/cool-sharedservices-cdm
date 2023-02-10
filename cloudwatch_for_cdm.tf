# ------------------------------------------------------------------------------
# Provision the IAM policy that allows access the CDM CloudWatch data
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
      # There is no need to adjust the FQDNs for staging, since COOL
      # staging is not connected to CDM; this is because CDM cannot
      # handle the fact that COOL production and staging use the same
      # IPv4 IP space.
      "arn:aws:logs:${var.aws_region}:${local.sharedservices_account_id}:log-group:/instance-logs/ipa0.cool.cyber.dhs.gov:log-stream:messages",
      "arn:aws:logs:${var.aws_region}:${local.sharedservices_account_id}:log-group:/instance-logs/ipa0.cool.cyber.dhs.gov:log-stream:secure",
      "arn:aws:logs:${var.aws_region}:${local.sharedservices_account_id}:log-group:/instance-logs/ipa0.cool.cyber.dhs.gov:log-stream:audit",
      "arn:aws:logs:${var.aws_region}:${local.sharedservices_account_id}:log-group:/instance-logs/ipa1.cool.cyber.dhs.gov:log-stream:messages",
      "arn:aws:logs:${var.aws_region}:${local.sharedservices_account_id}:log-group:/instance-logs/ipa1.cool.cyber.dhs.gov:log-stream:secure",
      "arn:aws:logs:${var.aws_region}:${local.sharedservices_account_id}:log-group:/instance-logs/ipa1.cool.cyber.dhs.gov:log-stream:audit",
      "arn:aws:logs:${var.aws_region}:${local.sharedservices_account_id}:log-group:/instance-logs/ipa2.cool.cyber.dhs.gov:log-stream:messages",
      "arn:aws:logs:${var.aws_region}:${local.sharedservices_account_id}:log-group:/instance-logs/ipa2.cool.cyber.dhs.gov:log-stream:secure",
      "arn:aws:logs:${var.aws_region}:${local.sharedservices_account_id}:log-group:/instance-logs/ipa2.cool.cyber.dhs.gov:log-stream:audit",
      "arn:aws:logs:${var.aws_region}:${local.sharedservices_account_id}:log-group:/instance-logs/vpn:log-stream:messages",
      "arn:aws:logs:${var.aws_region}:${local.sharedservices_account_id}:log-group:/instance-logs/vpn:log-stream:secure",
      "arn:aws:logs:${var.aws_region}:${local.sharedservices_account_id}:log-group:/instance-logs/vpn:log-stream:audit",
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
