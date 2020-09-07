############################################
####    List of key resource details    ####
############################################
output "launch_template_id" {
  value = aws_launch_template.asg-temp.*.id
}

output "auto-scaling-group-id" {
  value = aws_autoscaling_group.wp-webservers.*.id
}
output "auto-scaling-group-name" {
  value = aws_autoscaling_group.wp-webservers.*.name
}

output "mysql_db_endpoint" {
  value = aws_db_instance.orion-db.*.address
}

output "mysql_db_status" {
  value = aws_db_instance.orion-db.*.status
}

output "target_grp_name" {
  value = aws_lb_target_group.webservers-lb-tg.*.name
}

output "loadbal_dns_name" {
  value = aws_lb.webservers-alb.*.dns_name
}


output "nat_instance_ip" {
  value = aws_instance.orion-nat-inst.*.public_ip
}


