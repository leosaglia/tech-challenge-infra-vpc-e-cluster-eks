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

data "aws_db_instance" "rds_instance" {
  db_instance_identifier = "tech-challenge-fast-food-postgres"
}

resource "aws_security_group_rule" "allow_app_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = tolist(data.aws_db_instance.rds_instance.vpc_security_groups)[0]
  source_security_group_id = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}