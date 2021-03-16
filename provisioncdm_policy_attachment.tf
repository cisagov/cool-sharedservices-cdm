# ------------------------------------------------------------------------------
# Attach to the ProvisionAccount role the IAM policy that allows
# provisioning of the CDM layer in the Shared Services account.
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "provisioncdm_policy_attachment" {
  provider = aws.sharedservicesprovisionaccount

  policy_arn = aws_iam_policy.provisioncdm_policy.arn
  role       = var.provisionaccount_role_name
}
