data "aws_availability_zones" "azs" {}

module "bog-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
  name    = "bog-vpc"
  cidr    = var.vpc_cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  azs = data.aws_availability_zones.azs.names

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}
