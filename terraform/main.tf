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

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
}


data "aws_availability_zones" "zones" {
  state = "available"
}

resource "aws_subnet" "primary" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = data.aws_availability_zones.zones.names[0]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "secondary" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.zones.names[1]
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_route_table_association" "primary_rt_association" {
  subnet_id      = aws_subnet.primary.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "secondary_rt_association" {
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_lb" "alb" {
  name               = "tf-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.primary.id, aws_subnet.secondary.id]
  depends_on         = [aws_internet_gateway.gateway]
}

resource "aws_lb_target_group" "group" {
  name        = "tf-fargate-demo-tg"
  port        = "80"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  depends_on = [aws_lb.alb]
}

resource "aws_lb_listener" "server" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hello world"
      status_code  = "200"
    }
  }

  /* default_action { */
  /*   type             = "forward" */
  /*   target_group_arn = aws_lb_target_group.group.arn */
  /* } */

  depends_on = [aws_lb_target_group.group]
}


