terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      #version = "~> 1.45"
    }
  }
  required_version = ">= 0.13"
}
