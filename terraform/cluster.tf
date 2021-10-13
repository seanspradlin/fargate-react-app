resource "aws_ecs_cluster" "cluster" {
  name               = "tf-${var.project}-${var.environment}-cluster"
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = "100"
  }

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.log_encryption_key.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.task_logs.name
      }
    }
  }
  depends_on = [aws_kms_key.log_encryption_key]
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.task.name
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = var.task.cpu
  memory                   = var.task.memory
  container_definitions = jsonencode([
    {
      name      = var.task.name
      image     = "${aws_ecr_repository.repository.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.task.port
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.task_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "service" {
  name                              = var.task.name
  cluster                           = aws_ecs_cluster.cluster.id
  task_definition                   = aws_ecs_task_definition.task.arn
  launch_type                       = "FARGATE"
  desired_count                     = var.task.instance_count
  health_check_grace_period_seconds = 300

  network_configuration {
    security_groups  = [aws_security_group.task_sg.id]
    subnets          = [aws_subnet.primary.id, aws_subnet.secondary.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.group.arn
    container_name   = var.task.name
    container_port   = var.task.port
  }

  deployment_controller {
    type = "ECS"
  }
}
