variable vsphere_user {
  default = "administrator@vsphere.local"
}

variable vsphere_password {
  default = "Passw0rd!"
}

variable vsphere_server {
  default = "vcsa.domain.com"
}

variable vsphere_datacenter {
  default = "Datacenter"
}

variable vsphere_cluster {
  default = "Cluster"
}

variable vsphere_datastore {
  default = "Datastore"
}

variable vsphere_network_management {
  default = "VM Network"
}

variable vsphere_network_untrust {
  default = "VM Network"
}

variable vsphere_network_trust {
  default = "VM Network"
}

variable vsphere_template_name {
  default = "PA-VM"
}

variable vsphere_vm_name {
  default = "NGFW"
}

variable vsphere_vm_cpus {
  default = "2"
} # VM-50/VM-300/VM-500/VM-700 = 2/4/8/16

variable vsphere_vm_memory {
  default = "4608"
}
