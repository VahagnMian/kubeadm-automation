data "aws_region" "current" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = local.cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = local.enable_nat_gateway
  enable_vpn_gateway = local.enable_vpn_gateway

  tags = local.tags
}

locals {
  region = data.aws_region.current.name
  vpc_name = "vpc-dev"
  cidr = "10.0.0.0/16"
  azs = ["${local.region}a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets = ["10.0.101.0/24"]
  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }

}