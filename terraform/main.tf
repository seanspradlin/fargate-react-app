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

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/22"
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_alb" "alb" {
  name               = "tf-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet.id]
}

resource "aws_alb_target_group" "group" {
  name        = "tf-fargate-demo-tg"
  port        = "8080"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  depends_on = [aws_alb.alb]
}

resource "aws_alb_listener" "server" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forwward"
    target_group_arn = aws_alb_target_group.group.arn
  }
}
