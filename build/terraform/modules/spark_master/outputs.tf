output private_ip {
  value = ["${scaleway_server.spark-master.private_ip}"]
}

output public_ip {
  value = ["${scaleway_server.spark-master.public_ip}"]
}

output id {
  value = "${scaleway_server.spark-master.id}"
}