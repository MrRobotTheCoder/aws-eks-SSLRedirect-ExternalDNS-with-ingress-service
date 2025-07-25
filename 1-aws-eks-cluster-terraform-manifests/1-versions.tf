# Terraform Settings Block
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.31"
     }  
  }
  # AWS S3 Bucket as backend for terraform.tfstate with State Locking
  backend "s3" {
    bucket = "aws-eks-with-terraform-remote-state-storage"
    key = "dev/eks-cluster/terraform.tfstate"
    region = "us-east-1"
    # For State Locking
    dynamodb_table = "dev-ekscluster"
  }
}

# Terraform Provider Block
provider "aws" {
  region = var.aws_region
}