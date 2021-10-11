resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/22"
}

resource "aws_security_group" "task_sg" {
  name   = "fargate-demo-task"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "Accept only on listener port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
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
  name   = "fargate-demo-lb"
  vpc_id = aws_vpc.vpc.id

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
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }
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

resource "aws_route_table" "public_routes" {
  vpc_id = aws_vpc.vpc.id
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
