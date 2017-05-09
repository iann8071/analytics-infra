variable "slave_private_ips" {
  type = "list"
}
variable "master_private_ip" {
  type = "list"
}
variable "mysql_private_ip" {
  type = "list"
}
variable "security_group" {}
variable "image" {}
variable "slave_placeholder" {
  type = "list"
  default = ["[spark-slave]"]
}
variable "mgmt_placeholder" {
  type = "list"
  default = ["[config-mgmt]"]
}
variable "mysql_placeholder" {
  type = "list"
  default = ["[mysql]"]
}
variable "master_placeholder" {
  type = "list"
  default = ["[spark-master]"]
}
variable "empty_string_placeholder" {
  type = "list"
  default = [""]
}

resource "scaleway_ip" "config-mgmt" {
  server = "${scaleway_server.config-mgmt.id}"
}

resource "scaleway_server" "config-mgmt" {
  name  = "config-mgmt"
  image = "${var.image}"
  security_group = "${var.security_group}"
  type  = "VC1S"

  provisioner "local-exec" {
    command = "echo -e '${join("\n", concat(var.slave_placeholder, var.slave_private_ips, var.empty_string_placeholder))}' > production"
  }

  provisioner "local-exec" {
    command = "echo -e '${join("\n", concat(var.master_placeholder, var.master_private_ip, var.empty_string_placeholder))}' >> production"
  }

  provisioner "local-exec" {
    command = "echo -e '${join("\n", concat(var.mgmt_placeholder, list(self.private_ip), var.empty_string_placeholder))}' >> production"
  }

  provisioner "local-exec" {
    command = "echo -e '${join("\n", concat(var.mysql_placeholder, var.mysql_private_ip, var.empty_string_placeholder))}' >> production"
  }

  provisioner "file" {
    source = "/root/ansible"
    destination = "/root"
    connection {
      host = "${self.private_ip}"
      type = "ssh"
      user = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }
}

resource "null_resource" "config-mgmt" {
  triggers {
    public_ip = "${scaleway_ip.config-mgmt.ip}"
  }

  provisioner "file" {
    source = "production"
    destination = "/root/ansible/production"
    connection {
      host = "${scaleway_server.config-mgmt.private_ip}"
      type = "ssh"
      user = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd ansible",
      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i production start_spark.yml --tags init-docker",
      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i production start_spark.yml --tags init-spark",
      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i production start_spark.yml --tags start-spark"
    ]
    connection {
      host = "${scaleway_server.config-mgmt.private_ip}"
      type = "ssh"
      user = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }
}