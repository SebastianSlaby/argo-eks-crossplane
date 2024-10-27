terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.16.1"
    }
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}