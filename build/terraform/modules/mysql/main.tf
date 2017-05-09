variable "security_group" {}
variable "image" {}

resource "scaleway_server" "mysql" {
  name  = "mysql"
  image = "${var.image}"
  security_group = "${var.security_group}"
  type  = "VC1S"
}