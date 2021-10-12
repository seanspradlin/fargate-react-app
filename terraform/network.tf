resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/22"
}

resource "aws_security_group" "task_sg" {
  name   = "tf-${var.project}-${var.task.name}-${var.environment}-task-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Accept only on listener port"
    from_port   = var.task.port
    to_port     = var.task.port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    description = "Allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb_sg" {
  name   = "tf-${var.project}-${var.environment}-alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Accept all HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Accept all TLS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Only connection to task port"
    from_port   = var.task.port
    to_port     = var.task.port
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
}

data "aws_availability_zones" "zones" {
  state = "available"
}

resource "aws_subnet" "primary" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = data.aws_availability_zones.zones.names[0]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "secondary" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.zones.names[1]
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public_routes" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_route_table_association" "primary_rt_association" {
  subnet_id      = aws_subnet.primary.id
  route_table_id = aws_route_table.public_routes.id
}

resource "aws_route_table_association" "secondary_rt_association" {
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.public_routes.id
}

resource "aws_route53_record" "www" {
  zone_id = var.hosted_zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}
