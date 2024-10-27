module "lb_controller_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "lb-controller"

  oidc_providers = {
    main = {
      provider_arn = data.aws_iam_openid_connect_provider.this.arn
      namespace_service_accounts = ["aws-lb-controller:*"]
    }
  }
}