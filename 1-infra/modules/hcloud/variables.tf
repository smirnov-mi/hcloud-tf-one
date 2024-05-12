variable "cluster_name" {
    type = string
}

variable "nodes" {
    type = map(object({
        name         = string
        server_type  = string
        private_ip   = string
    }))
}

variable "load_balancer" {
    type = object({
        type        = string
        private_ip  = string
    })
}

variable "network_name" {
  type=string
  default = "cluster-network"
}

variable "hcloud_location" {
  type=string
  default = "nbg1"
}

variable "hcloud_image" {
  type=string
  default = "ubuntu-24.04"
}

variable "volume_size" {
  type=number
  default = 10
}
