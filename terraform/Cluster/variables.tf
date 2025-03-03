variable "eks_cluster_name" {}
variable "eks_version" {}
variable "lab_role_arn" {}
variable "vpc_id" {}
variable "private_subnets" {
  type = list(string)
}