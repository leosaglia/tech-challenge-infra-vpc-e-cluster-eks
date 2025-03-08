terraform {
  backend "s3" {
    bucket = "state-terraform-tech"
    key = "tech-challenge-infra-vpc-e-cluster-eks/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}