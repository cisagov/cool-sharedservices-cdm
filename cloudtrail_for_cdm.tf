module "cdm_cloudtrail" {
  source = "github.com/cisagov/cool-cdm-cloudtrail-tf-module?ref=improvement%2Fsupport-newest-aws-provider"
  providers = {
    aws       = aws.sharedservicesprovisionaccount
    aws.users = aws.usersprovisionaccount
  }

  assume_role_policy_description = var.cdm_cloudtrail_assume_role_policy_description
  assume_role_policy_name        = var.cdm_cloudtrail_assume_role_policy_name
  cdm_user_name                  = var.cdm_user_name
}
