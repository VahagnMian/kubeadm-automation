locals {
  account_id = data.aws_caller_identity.current.account_id
  #region = data.aws_region.current.name
  region = "eu-west-1"
  host = module.eks.cluster_endpoint
  certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token = data.aws_eks_cluster_auth.cluster.token

}
