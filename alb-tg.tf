###   Provision our AWS Application Load Balancers  ###

resource "aws_lb" "webservers-alb" {
  name               = "webservers-loadbal"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-secgrp.id]
  subnets            = [aws_subnet.orion-subnetd.id, aws_subnet.orion-subnete.id, aws_subnet.orion-subnetf.id]
  ip_address_type    = "ipv4"
  enable_deletion_protection = false

  tags = {
    Environment = "Orion"
  }
}

###  Create the Target Group for the Application Load Balancer  ###

resource "aws_lb_target_group" "webservers-lb-tg" {
  name     = "loadbal-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.orion-vpc.id
  health_check {
   enabled = true
   path = var.healthchk-path-tg
   matcher = "200-299"
   }

  tags = {
   Name = "alb-targetgrp"
   }
}

###   Create the Listener for our Target Group   ###

resource "aws_lb_listener" "targetgrp_listnr" {
  load_balancer_arn = aws_lb.webservers-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webservers-lb-tg.arn
  }
}