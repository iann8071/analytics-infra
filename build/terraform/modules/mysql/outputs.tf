output private_ip {
  value = ["${scaleway_server.mysql.private_ip}"]
}

output public_ip {
  value = ["${scaleway_server.mysql.public_ip}"]
}

output id {
  value = "${scaleway_server.mysql.id}"
}