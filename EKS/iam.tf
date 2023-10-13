resource "aws_iam_role" "lb-admin-sa" {
  name = "AmazonEKSLoadBalancerControllerRole"
  assume_role_policy = templatefile("${path.module}/resources/trust-relationship.json", {
    account_id = data.aws_caller_identity.current.account_id
    oidc_provider = module.eks.oidc_provider
    namespace = "kube-system"
    sa_name="aws-load-balancer-controller"
  })

  managed_policy_arns = [
    aws_iam_policy.lb.arn
  ]
}

resource "aws_iam_policy" "lb" {
  name = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/resources/iam_policy.json")
}

#resource "kubernetes_annotations" "patch-sa" {
#  api_version = "v1"
#  kind        = "ServiceAccount"
#  metadata {
#    name = "aws-load-balancer-controller"
#    namespace = "kube-system"
#  }
#  annotations = {
#    "eks.amazonaws.com/role-arn" = aws_iam_role.lb-admin-sa.arn
#  }
#}

output "oidc-provider" {
  value = module.eks.oidc_provider
}

#resource "helm_release" "aws-load-balancer-controller" {
#  name       = "aws-load-balancer-controller"
#  repository = "https://aws.github.io/eks-charts"
#  chart      = "aws-load-balancer-controller"
#  version    = "1.4.7"
#  namespace  = "kube-system"
#
#  set {
#    name  = "clusterName"
#    value = "eks"
#  }
#
#  set {
#    name  = "serviceAccount.name"
#    value = "aws-load-balancer-controller"
#  }
#
#  set {
#    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.lb-admin-sa.name}"
#  }
#}

#eksctl create iamserviceaccount \
#  --cluster=eks \
#  --namespace=kube-system \
#  --name=aws-load-balancer-controller \
#  --role-name lb-admin \
#  --attach-policy-arn=arn:aws:iam::929096969849:policy/AWSLoadBalancerControllerIAMPolicy \
#  --approve