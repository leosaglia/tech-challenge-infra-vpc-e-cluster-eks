resource "aws_eks_cluster" "eks" {
    name     = var.eks_cluster_name
    version = var.eks_version
    role_arn = var.eks_role_arn

    vpc_config {
        endpoint_public_access  = true
        endpoint_private_access = false
        subnet_ids              = aws_subnet.private.*.id
    }
}