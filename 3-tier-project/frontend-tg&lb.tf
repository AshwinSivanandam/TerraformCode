resource "aws_lb_target_group" "frontend-tg" {
  name       = "frontend-tg"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = [aws_vpc.vpc_main.id]
  depends_on = [aws_vpc.vpc_main.id]

}

resource "aws_lb" "frontend-lb" {
  name               = "frontend-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-frontend-sg.id]
  subnets            = [aws_sub.pub1, aws_subnet.pub2]
  tags = {
    Name = "ALB-Frontend"
  }
  depends_on = [aws_lb_target_group.frontend-tg]

}

resource "aws_lb_listener" "frontend-listener" {
  load_balancer_arn = aws_lb.frontend-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend-tg.arn
  }
  depends_on = [aws_lb_target_group.frontend-tg]

}