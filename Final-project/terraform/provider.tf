provider "aws" {
  region  = var.region
  profile = var.iam_profile
}

provider "kubernetes" {
  host                   = aws_eks_cluster.vasylkly.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.vasylkly.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.vasylkly.token
}

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.12.1"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.vasylkly.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.vasylkly.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.vasylkly.token
  }
}

data "aws_availability_zones" "available" {}
