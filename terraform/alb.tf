provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "aws_iam_policy" "albingress" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "AWS LoadBalancer Controller IAM Policy"

  policy = file("resources/iam-policy.json")
}

module "iam_oidc_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.0"
  create_role = true
  role_name = "role-with-oidc"
  provider_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns = [aws_iam_policy.albingress.arn]
  number_of_role_policy_arns = 1
}

resource "helm_release" "albingress" {
  name            = "alb"
  chart           = "aws-load-balancer-controller"
  version         = var.alb_ingress_version
  repository      = "https://aws.github.io/eks-charts"
  namespace       = "kube-system"
  cleanup_on_fail = true

  dynamic "set" {
    for_each = {
      "clusterName"                                                 = var.eks_name
      "vpcId"                                                       = module.vpc.vpc_id
      "region"                                                      = var.aws_region
      "serviceAccount.name"                                         = "alb"
      "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"   = module.iam_oidc_role.iam_role_arn
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}
