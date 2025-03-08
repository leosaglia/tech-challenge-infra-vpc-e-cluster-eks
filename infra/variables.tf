variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_block" {
  description = "The CIDR range for the VPC. This should be a valid private (RFC 1918) CIDR range."
  default     = "10.0.0.0/16"
}

variable "public_subnet_blocks" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.64.0/19", "10.0.96.0/19"]
}

variable "private_subnet_blocks" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  default     = "tech-challenge-cluster"  
}

variable "eks_version" {
  description = "The desired Kubernetes version for the EKS cluster"
  default     = "1.32" // atualizar
  
}

variable "eks_role_arn" {
  description = "The name of the IAM role to create for EKS"
  default     = "arn:aws:iam::759334756834:role/LabRole" // atualizar
}

variable "node_group_role_arn" {
  description = "The name of the IAM role to create for the EKS node group"
  default     = "arn:aws:iam::759334756834:role/LabRole" // atualizar
}
