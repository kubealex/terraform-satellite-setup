terraform {
 required_version = ">= 1.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.14"
    }
  }
}

resource "libvirt_pool" "vm_pool" {
  name = var.libvirt_pool
  type = "dir"
  path = "${var.libvirt_pool_path}/${var.libvirt_pool}"
}

resource "libvirt_network" "vm_network" {
  autostart = true
  name = var.libvirt_network
  mode = "nat"
  domain = var.domain
  addresses = var.network_cidr
  bridge = var.libvirt_network

  dns {
    enabled = true
    local_only = true
  }

  dnsmasq_options {
    options  {
        option_name = "server"
        option_value = "/${var.domain}/${cidrhost(var.network_cidr[0],1)}"
      }
  }
}