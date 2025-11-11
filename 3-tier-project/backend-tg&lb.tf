resource "aws_lb_target_group" "backend_tg" {
  name       = "backend_tg"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.vpc_main.id
}

resource "aws_lb" "backend_lb" {
  name               = "backend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_backend_sg.id]
  subnets            = [aws_subnet.pub1.id, aws_subnet.pub2.id]

  tags = {
    Name = "ALB-backend"
  }
}

resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.backend_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}
