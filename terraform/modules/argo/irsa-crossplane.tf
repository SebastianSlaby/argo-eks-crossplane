module "crossplane_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "crossplane"

  oidc_providers = {
    main = {
      provider_arn = data.aws_iam_openid_connect_provider.this.arn
      namespace_service_accounts = ["crossplane-system:*"]
    }
  }
  assume_role_condition_test = "StringLike"
}

resource "aws_iam_role_policy_attachment" "crossplane" {
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
    role = module.crossplane_irsa_role.iam_role_name
}