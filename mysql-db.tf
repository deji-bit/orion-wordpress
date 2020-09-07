
###  Provision our Aurora-MySQL RDS  ###

resource "aws_db_instance" "orion-db" {
  identifier           = var.db-identifier
  allocated_storage    = 20
  storage_type         = var.storage-type
  engine               = var.engine
  engine_version       = var.engine-vers
  instance_class       = var.db-inst-class
  availability_zone    = var.db-az
  db_subnet_group_name = aws_db_subnet_group.db_subgrp.name
  vpc_security_group_ids = [aws_security_group.db-secgrp.id]
  name                 = var.db-name
  username             = var.db-username
  password             = var.db-passwd
  port                 = var.db-port
  parameter_group_name = "default.mysql8.0"
  backup_retention_period = 7
  skip_final_snapshot  = "true"

  tags  = {
    Name = var.db-tag
   }
}


###   Define the Subnet Group for the RDS   ###

resource "aws_db_subnet_group" "db_subgrp" {
  name       = var.db-subnetgrp
  subnet_ids = [aws_subnet.orion-subneta.id, aws_subnet.orion-subnetb.id, aws_subnet.orion-subnetc.id]

  tags = {
    Name = var.db-subnet-grp
  }
}
