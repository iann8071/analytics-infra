variable "security_group" {}
variable "image" {}

resource "scaleway_ip" "spark-master" {
  server = "${scaleway_server.spark-master.id}"
}

resource "scaleway_server" "spark-master" {
  name  = "spark-master"
  image = "${var.image}"
  security_group = "${var.security_group}"
  type  = "VC1S"
}