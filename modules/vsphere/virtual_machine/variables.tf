variable "name" {
  description = "Virtual Machine Name"
  default     = "NGFW"
}

variable "resource_pool_id" {
  description = "vSphere Resource Pool ID"
}

variable "datastore_id" {
  description = "vSphere Datastore ID"
}

variable "num_cpus" {
  description = "vSphere VM Number of vCPUs"
  default     = "2"
}

variable "memory" {
  description = "vSphere VM amount of RAM in MB"
  default     = "4096"
}

variable "management_id" {
  description = "vSphere Mgmt Network ID"
}

variable "network_untrust_id" {
  description = "vSphere Untrust Network ID"
}

variable "network_trust_id" {
  description = "vSphere Trust Network ID"
}

variable "template_uuid" {
  description = "OVF Template UUID"
}

variable "guest_id" {
  default = "centos64Guest"
}

variable "scsi_type" {
  default = "lsilogic"
}

variable "wait_for_guest_ip_timeout" {
  default = "5"
}

variable "wait_for_guest_net_timeout" {
  default = "0"
}

variable "adapter_type" {
  default = "vmxnet3"
}

variable "disk_size" {
  description = "Boot Disk VM Disk Size"
  default = "60"
}

variable "cdrom_client_device" {
  default = "false"
}