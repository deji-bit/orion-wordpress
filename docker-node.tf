
###  Provision an EC2 Instance to serve as our Docker box in a public subnet inside our VPC  ###

resource "aws_instance" "orion-dockr-inst" {
  ami                    = var.dockr-ami
  instance_type          = var.instance-type
  key_name               = var.key-name
  subnet_id              = aws_subnet.orion-subnetf.id
  vpc_security_group_ids = [aws_security_group.dockr-inst-secgrp.id]
  user_data = file(var.dockr-user-data)
  
  tags = {
    Name = var.orion-dockrinst-tag
  }
}
output "dockrnode_ip_address_is" {
  value = aws_instance.orion-dockr-inst.public_ip
}


###  Create the Security Group to attach to our Docker box  ###

resource "aws_security_group" "dockr-inst-secgrp" {
  name = "dockr-sg"
  vpc_id = aws_vpc.orion-vpc.id

  tags = {
    Name = "orion-dockr-sg"
    
  }

###  ALL INBOUND

# Docker port
  ingress {
    from_port         = 50000
    to_port           = 50000
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    description = "traffic allowed from all sources"
  }
# Jenkins WebUI port
  ingress {
    from_port         = 8080
    to_port           = 8080
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    description = "traffic allowed from all sources"
  }
# Prometheus WebUI port
  ingress {
    from_port         = 9090
    to_port           = 9090
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    description = "traffic allowed from all sources"
  }
# SSH port
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    description = "traffic allowed from all sources"
  }


###  ALL OUTBOUND 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow traffic to all destinations"
  }
}
