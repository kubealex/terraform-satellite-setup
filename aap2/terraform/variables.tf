variable domain {
  type        = string
  description = "Domain for the virtual machine fqdn"
  default     = "aapdemo.labs"
}

variable libvirt_network {
  type        = string
  description = "Name of libvirt network to be used for the VM"
  default     = "aap-lab"
}

variable libvirt_pool {
  type        = string
  description = "Name of libvirt pool to be used for the VM"
  default     = "aap-lab"
}

variable disk_size {
  type        = number
  description = "Size in GBs of root volume for the VM"
  default     = 40
}

variable network_cidr {
  type        = list
  description = "Network CIDR for libvirt network definition"
  default     = ["192.168.216.0/24"]
}

variable libvirt_pool_path {
  type        = string
  description = "Path for libvirt pool definition"
  default     = "/var/lib/libvirt/images"
}
