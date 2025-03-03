resource "aws_eks_cluster" "eks" {
    name     = var.eks_cluster_name
    version  = var.eks_version
    role_arn = var.lab_role_arn

    vpc_config {
        endpoint_public_access  = true
        endpoint_private_access = false
        subnet_ids              = var.private_subnets
    }
}