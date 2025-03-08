resource "aws_eks_node_group" "main" {
    cluster_name    = aws_eks_cluster.eks.name
    version         = var.eks_version
    node_group_name = "tech-challenge-node-group"
    node_role_arn   = var.lab_role_arn

    subnet_ids      = var.private_subnets

    scaling_config {
        desired_size = 1
        max_size     = 2
        min_size     = 1
    }

    tags = {
        Name = "tech-challenge-node-group"
    }
}