provider "aws" {
  region = "eu-west-1"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "eks"
}

provider "kubernetes" {
  host                   = local.host
  token                  = local.token
  cluster_ca_certificate = local.certificate
}

provider "helm" {
  kubernetes {
  host                   = local.host
  token                  = local.token
  cluster_ca_certificate = local.certificate
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
    helm = ">= 2.0"
  }
}
