terraform {

/*
  cloud {
    workspaces {
      name = "learn-terraform-eks"
    }
  }
*/

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.27.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.3"
    }
  }


}