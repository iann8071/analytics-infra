variable "security_group" {}
variable "count" {}
variable "image" {}

resource "scaleway_server" "spark-slave" {
  count = "${var.count}"
  name  = "${format("spark-slave-%02d", count.index + 1)}"
  image = "${var.image}"
  security_group = "${var.security_group}"
  type  = "VC1S"
}