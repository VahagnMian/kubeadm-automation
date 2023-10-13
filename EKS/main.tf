module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.12.0"

  cluster_name    = "eks"
  cluster_version = "1.24"

  cluster_endpoint_public_access  = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnets

  eks_managed_node_groups = {
    regular = {
      min_size     = 2
      max_size     = 2
      desired_size = 2

      instance_types = ["t2.medium"]
    }
  }



  #https://oidc.eks.eu-west-1.amazonaws.com/id/42C78005E1CF70C1202CA7A7CF36EC5D

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${local.account_id}:user/mianv"
      username = "mianv"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    local.account_id
  ]

  tags = {
    "k8s.io/cluster-autoscaler/eks" = "owned"
    "k8s.io/cluster-autoscaler/enabled"             = "true"
  }
}
