terraform {
  required_version = "1.0.4"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

terraform {
  backend "s3" {
    key            = "Jigar/whyowhy/terraform.tfstate"
    bucket         = "whyowhy-demo"
    region         = "us-east-2"
    encrypt        = true
    access_key     = "AKIAWN7BTWRNZSAK5EB4"
    dynamodb_table = "442317911131-terraform-s3-backend"
  }
}

module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  name                   = var.vpc_name
  azs                    = var.vpc_azs
  cidr                   = var.vpc_cidr
  private_subnets        = slice(cidrsubnets(var.vpc_cidr, 2,2,2,3,4,4), 0, 3)
  public_subnets         = slice(cidrsubnets(var.vpc_cidr, 2,2,2,3,4,4), 3, 6)
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  enable_dns_support     = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_name}"  = "owned"
    "kubernetes.io/role/elb"          = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_name}"  = "owned"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
