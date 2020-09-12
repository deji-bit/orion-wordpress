####################################################
####    Variables used for Provider resource    ####
####################################################
variable "region" {
 type = string
  default = "eu-west-2"
}

variable "zone-a" {
 type = string
 default = "eu-west-2a"
}

variable "zone-b" {
 type = string
 default = "eu-west-2b"
}

variable "zone-c" {
 type = string
 default = "eu-west-2c"
}

###################################################
####    Variables used for Network resource    ####
###################################################
variable "vpc_cidr_block" {
 type = string
  default = "172.31.4.0/22"
}

variable "subneta_cidr_block" {
 type = string
  default = "172.31.4.0/25"
}

variable "subnetb_cidr_block" {
 type = string
  default = "172.31.4.128/25"
}

variable "subnetc_cidr_block" {
 type = string
  default = "172.31.5.0/25"
}

variable "subnetd_cidr_block" {
 type = string
  default = "172.31.5.128/25"
}

variable "subnete_cidr_block" {
 type = string
  default = "172.31.6.0/25"
}

variable "subnetf_cidr_block" {
 type = string
  default = "172.31.6.128/25"
}

###############################################
####    Variables used for EC2 resource    ####
###############################################
variable "autoscalinggrp-name" {
  type = string
  default = "wp-web-servers"
}

variable "dockr-ami" {
 type = string
  default = "ami-09b89ad3c5769cca2"
}
variable "asg-lt-secgrp" {
 type = string
 default = "webserver-asg-lt-secgrp"
}

variable "desired" {
  type = string
  default = 2
}

variable "maximum" {
  type = string
  default = 3
}

variable "minimum" {
  type = string
  default = 1
}

variable "nat-autoscalinggrp-name" {
 type = string
 default = "webservers-nat"
}

variable "nat-asg-lt-ami" {
 type = string
 default = "ami-058f2428e3b1e8887"
}

variable "nat-image" {
 type = string
  default = "ami-058f2428e3b1e8887"
}

variable "key-name" {
 type = string
 default = "first_keys"
}

variable "instance-type" {
 type = string
 default = "t2.micro"
}

# User Data for Launch Template
variable "user-data" {
  #  type    = string
  default = "dbconfig.tpl"
}

# User Data for Docker
variable "dockr-user-data" {
  #  type    = string
  default = "dockrinstall.tpl"
}

#variable "instance-count" {
# type = string
# default = "1"
#}

###############################################
####    Variables used for RDS resource    ####
###############################################
variable "storage-type" {
  type = string
  default = "gp2"
}

variable "engine" {
  type = string
  default = "mysql"
}

variable "engine-vers" {
  type = string
  default = "8.0.17"
}

variable "db-az" {
 type = string
  default = "eu-west-2a"
}

variable "db-subnetgrp" {
 type = string
  default = "mysql_db_subgrp"
}

variable "db-name" {
 type = string
  default = "DB_WP_ORION"
}

variable "db-username" {
 type = string
  default = "Dadmin"
}

variable "db-passwd" {
 type = string
  default = "Dadminadm1n"
}

variable "db-port" {
 type = string
  default = 3306
}

variable "db-secgrp" {
 type = string
 default = "mySQL-db-secgrp"
}

variable "db-inst-class" {
 type = string
  default = "db.t2.micro"
}

variable "db-identifier" {
 type = string
  default = "orion-db"
}

################################################
####    Variables used for resource tags    ####
################################################
variable "orion-vpc-tag" {
 type = string
 default = "vpc-orion-wp"
}

variable "orion-sub-tag-a" {
 type = string
 default = "subneta-priv-wp"
}

variable "orion-sub-tag-b" {
 type = string
 default = "subnetb-priv-wp"
}

variable "orion-sub-tag-c" {
 type = string
 default = "subnetc-priv-wp"
}

variable "orion-sub-tag-d" {
 type = string
 default = "subnetd-pub-wp"
}

variable "orion-sub-tag-e" {
 type = string
 default = "subnete-pub-wp"
}

variable "orion-sub-tag-f" {
 type = string
 default = "subnetf-pub-wp"
}

variable "db-tag" {
 type = string
  default = "wp_mySQL_db"
}

variable "db-subnet-grp" {
  type = string
  default = "MySQL-DB-subnet-group"
}

variable "autoscalinggrp-tag" {
  type = string
  default = "wp-webservers-asg"
}

variable "asg-instance-tag" {
 type = string
 default = "wp-webervers"
}

variable "nat-autoscalinggrp-tag" {
 type = string
 default = "orion-natinstance-wp" 
}

variable "nat-asg-instance-tag" {
 type = string
 default = "wp-webervers-nat"
}

variable "orion-natinst-tag" {
 type = string
 default = "orion-natinstance-wp"
}

variable "orion-dockrinst-tag" {
 type = string
 default = "docker-node"
}


###############################
####    Other Variables    ####
###############################
variable "healthchk-path-tg" {
 type = string
 default = "/dejiblog/wp-admin/install.php"
}
