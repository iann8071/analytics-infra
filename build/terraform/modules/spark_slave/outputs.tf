output private_ips {
  value = ["${scaleway_server.spark-slave.*.private_ip}"]
}

output public_ips {
  value = ["${scaleway_server.spark-slave.*.public_ip}"]
}

output ids {
  value = ["${scaleway_server.spark-slave.*.id}"]
}