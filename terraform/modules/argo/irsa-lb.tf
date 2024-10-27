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

resource "aws_iam_role_policy_attachment" "lb_controller" {
    policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
    role = module.lb_controller_irsa_role.iam_role_name
}