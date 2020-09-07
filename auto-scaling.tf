### Provision an Auto-scaling Group for our Wordpress Web Servers  ###

resource "aws_autoscaling_group" "wp-webservers" {
  name = var.autoscalinggrp-name 
  vpc_zone_identifier = [aws_subnet.orion-subneta.id, aws_subnet.orion-subnetb.id, aws_subnet.orion-subnetc.id]
  desired_capacity   = var.desired
  max_size           = var.maximum
  min_size           = var.minimum
  target_group_arns = [aws_lb_target_group.webservers-lb-tg.arn]
  termination_policies = ["OldestInstance"]
  launch_template {
    id      = aws_launch_template.asg-temp.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = var.autoscalinggrp-tag
    propagate_at_launch = true
  }
}


#resource "aws_launch_template" "foobar" {
#  name_prefix   = "foobar"
#  image_id      = "ami-1a2b3c"
#  instance_type = "t2.micro"
#}
