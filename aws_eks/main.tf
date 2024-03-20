provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "bog-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "bog-vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "5.5.3"
  name            = "bog-vpc"
  cidr            = "10.0.0.0/16"
  public_subnets  = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                  = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"         = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.3"
    cluster_name = "${local.cluster_name}"
    cluster_version = "1.25"

    cluster_endpoint_public_access  = true

    vpc_id = module.bog-vpc.vpc_id
    subnet_ids = module.bog-vpc.private_subnets

    tags = {
      
    }

    eks_managed_node_groups = {
    one = {
      name = "worker-node-1"

      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }

    two = {
      name = "worker-node-2"

      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }

    three = {
      name = "worker-node-3"

      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}
