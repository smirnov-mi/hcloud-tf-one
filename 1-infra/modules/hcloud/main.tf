
data "hcloud_network" "private_net" {
    name = var.network_name
}

resource "hcloud_server" "cloud_nodes" {
  for_each = var.nodes

  name        = each.value.name
  image       = "ubuntu-24.04"
  server_type = each.value.server_type
  location    = var.hcloud_location
  ssh_keys    = ["access1"]
  #user_data = file("${path.module}/cloud-config.yaml")
  labels = {
        "env" = "prod"
        "lb" = "lb-prod1"
  }
  network {
    network_id = data.hcloud_network.private_net.id
        #network_id = data.hcloud_network.private_net.id
        #ip = each.value.private_ip
  }

  public_net {
    ipv4_enabled = false
    ipv6_enabled = false
  }

}

resource "hcloud_volume" "volumes" {
  for_each = var.nodes

  name = "${each.value.name}-volx"
  size = 10
  server_id = hcloud_server.cloud_nodes[each.key].id
  automount = false
}

resource "hcloud_server_network" "server_network" {
  for_each = var.nodes
  network_id = data.hcloud_network.private_net.id
  server_id  = hcloud_server.cloud_nodes[each.key].id
  ip         = each.value.private_ip
}


resource "hcloud_load_balancer" "load_balancer" {
  name       = "${var.cluster_name}-lb"
  load_balancer_type = var.load_balancer.type
  location   = var.hcloud_location
  #dynamic "target"{
  #  for_each = var.nodes
  #  content{
  #    type = "server"
  #    server_id= hcloud_server.cloud_nodes[target.key].id
  #  }
  #}
}

resource "hcloud_load_balancer_network" "server_network_lb" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  network_id = data.hcloud_network.private_net.id
  ip = var.load_balancer.private_ip
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  type             = "label_selector"
  use_private_ip   = true
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  #server_id        = hcloud_server.my_server.id
  label_selector   = "lb=lb-prod1"
  depends_on = [
    data.hcloud_network.private_net,
    hcloud_load_balancer.load_balancer,
    hcloud_load_balancer_network.server_network_lb
  ]
}

resource "hcloud_load_balancer_service" "load_balancer_service" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  protocol         = "http"
  listen_port      = 80
  destination_port = 80

  http {
    sticky_sessions = true
    cookie_name     = "EXAMPLE_STICKY"
  }
}


resource "hcloud_load_balancer_service" "load_balancer_service2" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  protocol         = "http"
  listen_port      = 443
  destination_port = 443
}

