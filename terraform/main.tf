data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.4.0"

  name               = "openwebui-ollama-eks-vpc"
  cidr               = var.vpc_cidr
  azs                = data.aws_availability_zones.available.names
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.50.0/24", "10.0.51.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
}

module "eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "21.4.0"
  name                                     = local.cluster_name
  kubernetes_version                       = var.kubernetes_version
  subnet_ids                               = module.vpc.private_subnets
  vpc_id                                   = module.vpc.vpc_id
  endpoint_public_access                   = true
  enable_cluster_creator_admin_permissions = true
  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }
  eks_managed_node_groups = {
    node_group = {
      instance_types = ["t4g.xlarge"]
      ami_type       = "AL2023_ARM_64_STANDARD"
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }
}
