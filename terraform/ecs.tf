resource "aws_ecs_cluster" "cluster" {
  name               = "tf-fargate-cluster"
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = "100"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "service"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.fargate.arn
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name      = "application"
      image     = aws_ecr_repository.repository.repository_url
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name                              = "tf-fargate-service-demo"
  cluster                           = aws_ecs_cluster.cluster.id
  task_definition                   = aws_ecs_task_definition.task.arn
  launch_type                       = "FARGATE"
  desired_count                     = 1
  health_check_grace_period_seconds = 300

  network_configuration {
    subnets          = [aws_subnet.primary.id, aws_subnet.secondary.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.group.arn
    container_name   = "application"
    container_port   = 8080
  }

  deployment_controller {
    type = "ECS"
  }
}
