variable "nb_instances" {
  description = "Number of Instances to Create"
  default     = "1"
}

variable "instance_name" {
  description = "Name of instances to create and append by 1"
  type        = "list"
  default     = []
}

variable "machine_type" {
  description = "Type of instance"
  default     = "n1-standard-4"
}

variable "zone" {
  description = "GCP Zone to associate with"
  type        = "list"
  default     = []
}

variable "machine_cpu" {
  description = "GCP Firewall Machine CPU"
  default     = "Intel Skylake"
}

variable "enable_ip_forward" {
  description = "Enable IP Forwarding"
  type        = "string"
  default     = true
}

variable "allow_stop_for_update" {
  description = "Allow stopping instance for updates"
  type        = "string"
  default     = true
}

variable "bootstrap_bucket" {
  description = "VM-Series Bootstrap Bucket to access"
  type        = "string"
  default     = ""
}

variable "management-sub_self_link" {
  description = "Management Interface Network Self Link"
  type        = "string"
  default     = ""
}

variable "untrust-sub_self_link" {
  description = "Untrust Interface Network Self Link"
  type        = "string"
  default     = ""
}

variable "trust-sub_self_link" {
  description = "Trust Interface Network Self Link"
  type        = "string"
  default     = ""
}

variable "image" {
  # default = "Your_VM_Series_Image"

  # /Cloud Launcher API Calls to images/
  default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-byol-814"
  # default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-bundle2-810"
  # default = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/vmseries-bundle1-810"
}

variable "scopes" {
  description = "Service Account Scoping Name"
  type        = "list"
}

variable "int_swap" {
  description = "Interface SWAP for VM-Series LB Support in GCP"
  default     = "enable"
}

variable "instance_type" {
  description = "Firewall or other"
  default     = "firewall"
}

variable "machine_type_web" {
  description = "GCP Machine Type"
  default     = "f1-micro"
}

variable "public_key" {
  description = "SSH Public Key"
  default     = ""
}

variable fw_nic0_ip {
  type    = "list"
  default = [""]
}

variable fw_nic1_ip {
  type    = "list"
  default = [""]
}

variable fw_nic2_ip {
  type    = "list"
  default = [""]
}

variable create_instance_group {
  default = false
}

variable instance_group_names {
  type    = "list"
  default = ["vmseries-instance-group"]
}

variable "port_name" {
  type    = "string"
  default = "http"
}

variable "port" {
  type = "string"
  default = "80"
}

variable "dependencies" {
  type    = "list"
  default = [""]
}