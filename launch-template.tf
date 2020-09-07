###  Create the launch template for our Auto-scaling Group  ###

resource "aws_launch_template" "asg-temp" {
  name = "webserver-asg-lt"
  block_device_mappings {
    device_name = "/dev/xvda"

      ebs {
        volume_size = 8
      }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_termination = true
  ebs_optimized = false
  image_id = var.asg-lt-ami
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = var.instance-type
  key_name = var.key-name
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  monitoring {
    enabled = true
  }
  vpc_security_group_ids = [aws_security_group.asg-lt-secgrp.id]
  tag_specifications {
    resource_type = "instance"

      tags = {
        Name = var.asg-instance-tag
      }
  }
  user_data = base64encode(data.template_file.db-template.rendered)
  # user_data = data.template_file.db-template.rendered
  # user_data = filebase64(var.user-data)

}

