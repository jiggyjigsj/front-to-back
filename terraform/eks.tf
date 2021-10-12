data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.eks_name
  cluster_version = 1.21
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  enable_irsa     = true

  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
        }
      ]
    }
    kubesystem = {
      name = "kubesystem"
      selectors = [
        {
          namespace = "kube-system"
        }
      ]
    }
    "${var.namespace}" = {
      name = var.namespace
      selectors = [
        {
          namespace = var.namespace
        }
      ]
    }
  }
}

# Workaround for coredns deployment
# https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1286#issuecomment-811157662
resource "null_resource" "coredns" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    when    = create
    command = "kubectl apply -f resources/coredns.yaml -n kube-system --kubeconfig kubeconfig_${var.eks_name}"
  }
}
