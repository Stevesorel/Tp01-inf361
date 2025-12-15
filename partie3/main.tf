terraform {
  required_providers {
    ssh = {
      source = "loafoe/ssh"
    }
  }
}

provider "ssh" {
  host     = var.server_ip
  user     = var.ssh_user
  password = var.ssh_password
}

resource "ssh_remote_exec" "create_users" {
  commands = [
    "apt-get update",
    "apt-get install -y python3 ansible",
    "cd /tmp && git clone https://github.com/votre-repo/create_users.git",
    "cd /tmp/create_users && ansible-playbook -i inventory.ini create_users.yml"
  ]

  connection {
    type        = "ssh"
    host        = var.server_ip
    user        = var.ssh_user
    password    = var.ssh_password
    timeout     = "5m"
  }
}
