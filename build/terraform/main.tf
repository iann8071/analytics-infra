variable "slave_count" {}
variable "image" {}
variable "config_mgmt_image" {}
variable "organization" {}
variable "token" {}

provider "scaleway" {
  organization = "${var.organization}"
  token        = "${var.token}"
  region       = "par1"
}

module "security_group" {
  source = "./modules/security_group"
}

module "spark_master" {
  source = "./modules/spark_master"
  security_group = "${module.security_group.id}"
  image = "${var.image}"
}

module "mysql" {
  source = "./modules/mysql"
  security_group = "${module.security_group.id}"
  image = "${var.image}"
}

module "spark_slave" {
  source = "./modules/spark_slave"
  security_group = "${module.security_group.id}"
  count = "${var.slave_count}"
  image = "${var.image}"
}

module "config_mgmt" {
  source = "./modules/config_mgmt"
  slave_private_ips = "${module.spark_slave.private_ips}"
  master_private_ip = "${module.spark_master.private_ip}"
  mysql_private_ip = "${module.mysql.private_ip}"
  security_group = "${module.security_group.id}"
  image = "${var.config_mgmt_image}"
}