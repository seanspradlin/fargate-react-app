resource "aws_lb" "alb" {
  name               = "tf-${var.project}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.primary.id, aws_subnet.secondary.id]
  security_groups    = [aws_security_group.lb_sg.id]
  depends_on         = [aws_internet_gateway.gateway]
}

resource "aws_lb_target_group" "group" {
  name        = "tf-${var.project}-${var.task.name}-${var.environment}-tg"
  port        = var.task.port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  depends_on = [aws_lb.alb]

  health_check {
    matcher = "200"
    path    = var.task.healthcheck
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group.arn
  }
}

