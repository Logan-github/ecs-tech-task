data "template_file" "demp-app-green" {
  template = file("./templates/image-green.json")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "demo-task-definition-green" {
  family                   = "demo-app-task-green"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.demo-app-green.rendered
}

resource "aws_ecs_service" "demo-service-green" {
  name            = "demo-app-service-green"
  cluster         = aws_ecs_cluster.demo-cluster.id
  task_definition = aws_ecs_task_definition.demo-task-definition-green.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.sg-demo-ecs.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.demo-green-tg.arn
    container_name   = "demo-app-green"
    container_port   = var.app_port
  }

  depends_on = [aws_lb_listener.demo-app, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

#load balancer for green deployment
resource "aws_lb_target_group" "demo-green-tg" {
  name        = "demo-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.demo-vpc.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    matcher             = "200"
    path                = var.health_check_path
    interval            = 30
  }
}