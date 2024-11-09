resource "helm_release" "argo" {
  name       = "argo-release"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.10.0"
  namespace = "argocd"
  create_namespace = true

  values = [
    "${file("${path.module}/manifests/values.yaml")}"
  ]
}

resource "kubernetes_secret" "repo" {
  depends_on = [ helm_release.argo ]
  metadata {
    name = "main-repo"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    type = "git"
    url = "https://github.com/SebastianSlaby/argo-eks-crossplane"
  }
}

# Deploy this with Helm and set dependencies to avoid errors about CRDs not existing
resource "kubernetes_manifest" "app_of_apps" {
  manifest = yamldecode(file("${path.module}/manifests/app-of-apps.yaml"))
}

resource "kubernetes_secret" "cluster" {
  depends_on = [ helm_release.argo ]
  metadata {
    name = var.cluster_name
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
    annotations = {
      "clusterName" = var.cluster_name
      "lbControllerArn" = module.lb_controller_irsa_role.iam_role_arn
    }
  }
  data = {
    name: var.cluster_name
    server: "https://kubernetes.default.svc"
  }
}