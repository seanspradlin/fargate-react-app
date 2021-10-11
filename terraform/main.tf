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

module "network" {
  source         = "./network"
  hosted_zone_id = var.hosted_zone_id
}

module "cluster" {
  source                       = "./cluster"
  public_subnets               = module.network.public_subnets
  application_target_group_arn = module.network.application_target_group_arn
  ecr_url                      = module.repository.ecr_url
}

module "repository" {
  source = "./repository"
}

