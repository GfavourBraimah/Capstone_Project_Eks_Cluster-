# variables.tf

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

variable "cluster_name" {
  type    = string
  default = "bog-eks"
}

variable "cluster_version" {
  type    = string
  default = "1.24"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t2.medium"]
}
