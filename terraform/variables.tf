# AWS Provider
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}

# VPC Module
variable "vpc_name" {}
variable "vpc_azs" {}
variable "vpc_cidr" {}
# Add additional vars for adding cidrs
# variable "additional_vpc_cidr" {}
# variable "vpc_private_subnets" {}
# variable "vpc_public_subnets" {}

variable "eks_name" {}
variable "namespace" {}
variable "alb_ingress_version" {}
