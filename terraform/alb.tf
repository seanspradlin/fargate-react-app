resource "aws_lb" "alb" {
  name               = "tf-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.primary.id, aws_subnet.secondary.id]
  security_groups    = [aws_security_group.lb_sg.id]
  depends_on         = [aws_internet_gateway.gateway]
}

resource "aws_lb_target_group" "group" {
  name        = "tf-application-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  depends_on = [aws_lb.alb]

  health_check {
    matcher = "200"
    path    = "/api/healthcheck"
  }

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
