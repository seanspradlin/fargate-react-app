resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/22"
}

resource "aws_security_group" "allow_web_traffic" {
  name        = "allow_web_traffic"
  description = "Allow HTTP and HTTPS"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "Accept all HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Accept all TLS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow all traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
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

resource "aws_lb" "alb" {
  name               = "tf-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.primary.id, aws_subnet.secondary.id]
  security_groups    = [aws_security_group.allow_web_traffic.id]
  depends_on         = [aws_internet_gateway.gateway]
}

resource "aws_route53_record" "www" {
  zone_id = var.hosted_zone_id
  name    = "dev.seanspradlin.com"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_lb_target_group" "group" {
  name        = "tf-application-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  depends_on = [aws_lb.alb]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "server" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group.arn
  }
}
