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

resource "aws_security_group" "rds_sg" {
  name        = "tech-challenge-rds-sg"
  description = "RDS PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_app_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}