# ------------------------------------------------------------------------------
# Create the IAM policy that allows all of the additional permissions
# necessary to provision the CDM layer in the Shared Services
# account.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "provisioncdm_policy_doc" {
  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
      "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "provisioncdm_policy" {
  provider = aws.sharedservicesprovisionaccount

  description = var.provisioncdm_policy_description
  name        = var.provisioncdm_policy_name
  policy      = data.aws_iam_policy_document.provisioncdm_policy_doc.json
}
