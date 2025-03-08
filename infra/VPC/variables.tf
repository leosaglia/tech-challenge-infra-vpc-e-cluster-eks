variable "vpc_block" {}
variable "aws_region" {}
variable "public_subnet_blocks" {
  type = list(string)
}
variable "private_subnet_blocks" {
  type = list(string)
}