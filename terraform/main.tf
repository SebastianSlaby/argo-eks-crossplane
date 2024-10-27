provider "aws" {
    region = "us-east-1"
}

module eks {
    source = "./modules/eks"
}

module "argo" {
    source = "./modules/argo"
    cluster_name = module.eks.cluster_name
}