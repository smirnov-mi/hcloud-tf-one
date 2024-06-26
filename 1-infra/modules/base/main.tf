resource "hcloud_network" "private_net" {
  name     = var.network_name
  ip_range = var.private_ip_range
  labels = {
    name = var.network_name
  }
}

resource "hcloud_network_subnet" "private_subnet" {
  network_id   = hcloud_network.private_net.id
  type         = "server"
  network_zone = var.private_network_zone
  ip_range     = var.private_ip_range
}

resource "hcloud_server" "bastion" {
  name        = var.bastion.name
  image       = "ubuntu-22.04"
  server_type = var.bastion.server_type
  location    = var.hcloud_location
  ssh_keys    = ["access1"]
}

resource "hcloud_server_network" "server_network_bastion" {
  network_id = hcloud_network.private_net.id
  server_id  = hcloud_server.bastion.id
  ip         = var.bastion.private_ip
}

resource "hcloud_ssh_key" "default" {
  name       = "access1"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "hcloud_network_route" "NAT-route" {
  network_id  = hcloud_network.private_net.id
  destination = "0.0.0.0/0"
  gateway     = var.bastion.private_ip
}
