#aws application laadbalancer and target group and alb http listener

resource "aws_lb" "demo-app" {
  name                  = "demo-app-load-balancer"
  load_balancer_type    = "application"
  subnets               = aws_subnet.public.*.id
  security_groups       = [aws_security_group.alb-sg.id]
}

#target groups are created in ecs-blue.tf and ecs-green.tf

#divert incoming traffic from ALB to demo blue/green target group
resource "aws_lb_listener" "demo-app" {
  load_balancer_arn = aws_lb.demo-app.id
  port              = var.app_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    forward {
        target_group {
          arn    = aws_lb_target_group.demo-blue-tg.arn
          weight = lookup(local.traffic_dist_map[var.traffic_distribution], "blue", 100)
        }

        target_group {
          arn    = aws_lb_target_group.demo-green-tg.arn
          weight = lookup(local.traffic_dist_map[var.traffic_distribution], "green", 0)
        }

        stickiness {
          enabled  = false
          duration = 1
        }
    }
  }
}