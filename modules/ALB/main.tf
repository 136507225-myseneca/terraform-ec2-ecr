provider "aws" {
  region = "us-east-1"
}

# Create an Application Load Balancer
resource "aws_lb" "my_alb" {
  name               = "my-application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups                      # Replace with your security group ID
  subnets            = [var.aws_subnet_id, var.aws_subnet_id_2] # Replace with your subnet IDs

  enable_deletion_protection = false

  tags = {
    Name = "my-alb"
  }
}


resource "aws_lb_target_group" "tg" {
  count    = 3
  name     = "tg-${count.index}"
  port     = 8081 + count.index
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}





# Listener for the ALB
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  # Default action to return a fixed response
  # This is just an example, adjust as needed
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 Not Found"
      status_code  = "404"
    }
  }
}


resource "aws_lb_listener_rule" "listener_rule" {
  count        = 3
  listener_arn = aws_lb_listener.listener.arn
  priority     = 100 + count.index

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[count.index].arn
  }

  condition {
    path_pattern {
      values = ["/app${count.index + 1}*"]
    }
  }
}


#

# Register EC2 instance with the target groups
resource "aws_lb_target_group_attachment" "tg_attach" {
  count            = 3
  target_group_arn = aws_lb_target_group.tg[count.index].arn
  target_id        = var.instance_id # Replace with your EC2 instance ID
  port             = 8081 + count.index
}
