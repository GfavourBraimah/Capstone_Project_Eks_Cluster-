provider "aws" {
  region = var.region
}


 module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.7.0"
  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  cluster_endpoint_public_access = true

  vpc_id     = module.bog-vpc.vpc_id
  subnet_ids = module.bog-vpc.private_subnets

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    # Add additional tags as needed
  }

  eks_managed_node_groups = {
    dev = {
      name           = "worker-node-1"
      instance_types = var.node_instance_types
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }
}
