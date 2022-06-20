variable hostname {
  type        = string
  description = "Hostname of the VM"
  default     = "controller"
}

variable domain {
  type        = string
  description = "Domain for the virtual machine fqdn"
  default     = "aapdemo.labs"
}
 
variable memory {
  type        = number
  description = "Amount of memory in GBs for the VM"
  default     = 16
}

variable cpu {
  type        = number
  description = "Amount of CPUs for the VM"
  default     = 4
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

variable os_image {
  type        = string
  description = "URL/path of the image to be used for the VM provisioning"
  default     = "rhel8.iso"
}

variable kickstart_image {
  type        = string
  description = "Path for the kickstart image"
  default     = "rhel8-controller-oemdrv.img"
}
