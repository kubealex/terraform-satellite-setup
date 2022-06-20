terraform {
 required_version = ">= 1.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.14"
    }
  }
}

resource "libvirt_volume" "os_image" {
  name = "${var.hostname}-os_image"
  pool = var.libvirt_pool
  format = "qcow2"
  size = var.disk_size*1073741824
}

resource "libvirt_volume" "kickstart_image" {
  name = "${var.hostname}-kickstart"
  pool = var.libvirt_pool
  source = abspath("${path.module}/${var.kickstart_image}")
  format = "qcow2"
}

resource "libvirt_domain" "sso_instance" {
  autostart = true
  name = var.hostname
  memory = var.memory*1024
  vcpu = var.cpu

  boot_device {
    dev = ["hd", "cdrom", "network"]
  }

  cpu {
    mode = "host-passthrough"
  }

  disk {
     file = abspath("${path.module}/${var.os_image}")
  }

  disk {
     volume_id = libvirt_volume.os_image.id
  }
  
  disk {
     volume_id = libvirt_volume.kickstart_image.id
  }

  network_interface {
       network_name = var.libvirt_network
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = "true"
  }
}

output "ips" {
  value = flatten(libvirt_domain.sso_instance.*.network_interface.0.addresses)
}

output "macs" {
  value = flatten(libvirt_domain.sso_instance.*.network_interface.0.mac)
}

