terraform {
  backend "s3" {
    bucket = "spradlin-tf-states"
    key    = "ecs-fargate-demo"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "development"
      Project     = "Fargate Test"
    }
  }
}

