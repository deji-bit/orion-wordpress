
###  Create the VPC for our Wordpress Hosting  ###

resource "aws_vpc" "orion-vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  instance_tenancy = "default"

  tags = {
    Name = var.orion-vpc-tag
  }
}

###  Create Internet Gateway to be used by the Public Subnets in our VPC  ###

resource "aws_internet_gateway" "orion-igw" {
  vpc_id = aws_vpc.orion-vpc.id
  
  tags = {
    Name = "igw-orion-wp"
  }
}

###  Create a Route Table to be used by our Internet Gateway  ###

resource "aws_route_table" "orion-rtb" {
  vpc_id = aws_vpc.orion-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.orion-igw.id
  }

  tags = {
    Name = "rtb-orion-wp"
  }
}

###  Create a Route Table to be used by the Private Subnets in our VPC  ###

resource "aws_route_table" "orion-priv-rtb" {
  vpc_id = aws_vpc.orion-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = aws_instance.orion-nat-inst.id
  }

  tags = {
    Name = "rtb-priv-orion-wp"
  }
}

###  Provision a NAT Instance to serve the Route Table used by the Private Subnets in our VPC  ###

resource "aws_instance" "orion-nat-inst" {
  ami                    = var.nat-image
  instance_type          = var.instance-type
  key_name               = var.key-name
  subnet_id              = aws_subnet.orion-subnetd.id
  vpc_security_group_ids = [aws_security_group.nat-inst-secgrp.id]
  source_dest_check      = false
#  count                  = var.instance-count
  
  tags = {
    Name = var.orion-natinst-tag
  }
}
 
###  Create 3 Private Subnets to launch our Web Servers and RDS Database in  ###

##  Subnet A
##  ========
resource "aws_subnet" "orion-subneta" {
  vpc_id            = aws_vpc.orion-vpc.id
  cidr_block        = var.subneta_cidr_block
  availability_zone = var.zone-a

  tags = {
    Name = var.orion-sub-tag-a
  }
}

##  Subnet B
##  ========
resource "aws_subnet" "orion-subnetb" {
  vpc_id  = aws_vpc.orion-vpc.id
  cidr_block = var.subnetb_cidr_block
  availability_zone = var.zone-b

  tags = {
    Name = var.orion-sub-tag-b
  }
}

##  Subnet C
##  ========
resource "aws_subnet" "orion-subnetc" {
  vpc_id  = aws_vpc.orion-vpc.id
  cidr_block        = var.subnetc_cidr_block
  availability_zone = var.zone-c

  tags = {
    Name = var.orion-sub-tag-c
  }
}

###  Create 3 additional Public Subnets to use for our Application Load Balancers and NAT Instance  ###

##  Subnet D
##  ========
resource "aws_subnet" "orion-subnetd" {
  vpc_id            = aws_vpc.orion-vpc.id
  cidr_block        = var.subnetd_cidr_block
  availability_zone = var.zone-a
  map_public_ip_on_launch = "true"

  tags = {
    Name = var.orion-sub-tag-d
  }
}

##  Subnet E
##  ========
resource "aws_subnet" "orion-subnete" {
  vpc_id  = aws_vpc.orion-vpc.id
  cidr_block        = var.subnete_cidr_block
  availability_zone = var.zone-b
  map_public_ip_on_launch = "true"

  tags = {
    Name = var.orion-sub-tag-e
  }
}

##  Subnet F
##  ========
resource "aws_subnet" "orion-subnetf" {
  vpc_id  = aws_vpc.orion-vpc.id
  cidr_block        = var.subnetf_cidr_block
  availability_zone = var.zone-c
  map_public_ip_on_launch = "true"

  tags = {
    Name = var.orion-sub-tag-f
  }
}

###  Associate a Route Table to our Private Subnets  ###

resource "aws_route_table_association" "orion-rtbassa" {
  subnet_id      = aws_subnet.orion-subneta.id
  route_table_id = aws_route_table.orion-priv-rtb.id
}

resource "aws_route_table_association" "orion-rtbassb" {
  subnet_id      = aws_subnet.orion-subnetb.id
  route_table_id = aws_route_table.orion-priv-rtb.id
}

resource "aws_route_table_association" "orion-rtbassc" {
  subnet_id      = aws_subnet.orion-subnetc.id
  route_table_id = aws_route_table.orion-priv-rtb.id
}

###  Associate a Route Table to our Public Subnets  ###

resource "aws_route_table_association" "orion-rtbassd" {
  subnet_id      = aws_subnet.orion-subnetd.id
  route_table_id = aws_route_table.orion-rtb.id
}

resource "aws_route_table_association" "orion-rtbasse" {
  subnet_id      = aws_subnet.orion-subnete.id
  route_table_id = aws_route_table.orion-rtb.id
}

resource "aws_route_table_association" "orion-rtbassf" {
  subnet_id      = aws_subnet.orion-subnetf.id
  route_table_id = aws_route_table.orion-rtb.id
}

###  Create the Security Group to attach to our RDS  ###

resource "aws_security_group" "db-secgrp" {
  name = var.db-secgrp
  vpc_id = aws_vpc.orion-vpc.id

  tags = {
    Name = "mySQL-db-sg"
  }

###  ALL INBOUND

# MySQL port
  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    cidr_blocks       = [var.vpc_cidr_block]   //  ["172.31.4.0/22"]
    description = "traffic allowed from sources within the network ONLY"
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

### Create the Security Group to attach to our ASG Launch Template  ###

resource "aws_security_group" "asg-lt-secgrp" {
  name = var.asg-lt-secgrp
  vpc_id = aws_vpc.orion-vpc.id

  tags = {
    Name = "wp-webserver-sg"
    
  }

###  ALL INBOUND

# Apache Webserevr port
  ingress {
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["172.31.4.0/22"]
    description = "traffic allowed from sources within the network ONLY"
  }
# MySQL port
  ingress {
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    cidr_blocks       = ["172.31.4.0/22"]
    description = "traffic allowed from sources within the network ONLY"
  }
# SSH port
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    description = "traffic allowed from sources within the network ONLY"
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

### Create the Security Group to attach to our Application Load Balancer  ###

resource "aws_security_group" "lb-secgrp" {
  name = "alb-secgrp"
  vpc_id = aws_vpc.orion-vpc.id

  tags = {
    Name = "app-loadbal-sg"
    
  }

###  ALL INBOUND

# Wordpress webUI port
  ingress {
    from_port         = 80
    to_port           = 80
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

### Create the Security Group to attach to our NAT Inshance  ###

resource "aws_security_group" "nat-inst-secgrp" {
  name = "nat-secgrp"
  vpc_id = aws_vpc.orion-vpc.id

  tags = {
    Name = "nat-instance-sg"
    
  }

###  ALL INBOUND

# SSH port
  ingress {
    from_port         = "0"
    to_port           = "0"
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]  // [aws_security_group.asg-lt-secgrp]
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
