locals {
  name            = "test-from-levani"
  cluster_version = "1.21"
  region          = "us-east-2"
  vpc_id          = "vpc-16f3857d"
  subnets         = ["subnet-b40698df", "subnet-e69b4c9b", "subnet-2f073863"] 
  instance_type   = "t2.large"
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}


module "eks" {
  source          = "terraform-aws-modules/eks/aws" 
  cluster_version = local.cluster_version
  cluster_name    = local.name
  vpc_id          = local.vpc_id
  subnets         = local.subnets
	
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  worker_groups = [
    {
      instance_type = local.instance_type
      asg_max_size  = 5
    }
  ]
}
