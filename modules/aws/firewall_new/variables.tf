# Firewall Deployment Variables
variable "eni_attachment_ids" {
  description = "list of enis to attach"
  type = "list"
  default = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "management_enis" {
  description = "list of management eni to attach"
  type = "list"
  default = []
}

variable "untrust_enis" {
  description = "list of untrust enis to attach"
  type = "list"
  default = []
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type = "list"
  default = []
}

variable "fw_key_name" {
  description = "SSH Public Key to use w/firewall"
  default = ""
}

variable "fw_key" {
  description = "SSH Public Key"
  default = ""
}

# Firewall version for AMI lookup

variable "fw_version" {
  description = "Select which FW version to deploy"
  default = "8.1.0"
  # Acceptable Values Below
  #default = "6.1.18"
  #default = "7.0.17"
  #default = "7.1.11"
  #default = "7.1.14"
  #default = "7.1.17"
  #default = "7.1.18"
  #default = "7.1.20"
  #default = "8.0.3"
  #default = "8.0.6"
  #default = "8.0.8"
  #default = "8.0.9"
  #default = "8.0.13"
  #default = "8.1.0"
}

# License type for AMI lookup
variable "fw_license_type" {
  description = "Select License type (byol/payg1/payg2)"
  default = "byol"
}

# Product code map based on license type for ami filter

variable "fw_license_type_map" {
  type = "map"
  default =
    {
      "byol" = "6njl1pau431dv1qxipg63mvah",
      "payg1" = "6kxdw3bbmdeda3o6i1ggqt4km",
      "payg2" = "806j2of0qy5osgjjixq9gqc6g",
    }
}

variable "fw_priv_key_path" {
  description = "SSH Private Key Full Path"
  type = "string"
  default = ""
}

variable "username" {
  description = "Username of firewall"
  type = "string"
  default = "admin"
}

variable "password" {
  description = "Password of associated username"
  type = "string"
  default = ""
}

variable "mgmt_sleep" {
  description = "Amount of time to wait until configuring intial admin access"
  type = "string"
  default = "240"
}

variable "go_path" {
  description = "Path to execute GO Initalization binary"
  default = ""
}

variable "management_elastic_ip_addresses" {
  description = "list of mgmt elastic ip addresses to be passed through for reference by CM"
  type = "list"
  default = []
}

variable "untrust_elastic_ip_addresses" {
  description = "list of untrust elastic ip addresses to be passed through for reference by other modules"
  type = "list"
  default = []
}

variable "customer_gw_asn" {
  description = "Firewall BGP ASNs to be used for customer gw"
  type = "list"
  default = []
}


/*
# s3 bucket for bootstrapping the firewall1
variable "MasterS3Bucket" {}
variable "bootstrap1" {}
variable "bootstrap2" {}
variable "bootstrap3" {}
variable "bootstrap4" {}
*/


/*
##Variables for autoscaling##
output "PanFwAmiId" {
  value = "${var.PanFwAmiId}"
}

output "VPCID" {
  value = "${aws_vpc.main.id}"
}

output "KeyName" {
  value = "${var.KeyName}"
}

output "KeyPANWPanorama" {
  value = "${var.KeyPANWPanorama}"
}

output "KeDeLicense" {
  value = "${var.KeyDeLicense}"
}

output "MasterS3Bucket" {
  value = "${var.MasterS3Bucket}"
}

output "NATGateway" {
  value = "${var.NATGateway}"
}

output "SSHLocation" {
  value = "${var.SSHLocation}"
}
*/

