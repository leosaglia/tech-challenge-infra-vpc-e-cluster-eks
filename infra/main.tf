module "vpc" {
  source                = "./VPC"
  vpc_block             = var.vpc_block
  public_subnet_blocks  = var.public_subnet_blocks
  private_subnet_blocks = var.private_subnet_blocks
  aws_region            = var.aws_region
}

module "cluster" {
  source              = "./Cluster"
  depends_on          = [module.vpc]
  eks_cluster_name    = var.eks_cluster_name
  eks_version         = var.eks_version
  lab_role_arn        = var.eks_role_arn

  # Usa as saídas do módulo VPC para VPC e subnets
  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.vpc.private_subnets
}

module "complementos-cluster" {
  source = "./Complementos-Cluster"
  depends_on = [ module.cluster ]
}