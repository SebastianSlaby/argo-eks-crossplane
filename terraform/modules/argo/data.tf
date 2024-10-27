data "aws_eks_cluster" "main" {
    name = var.cluster_name
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.main.identity[0].oidc[0].issuer
}