# Firewall Deployment Variables
variable "region" {
  default = "us-east-1"
}
variable "trust_subnets" {
  description = "list of trusted subnet ids"
  type = "list"
  default = []
}

variable "untrust_subnets" {
  description = "list of untrusted subnet ids"
  type = "list"
  default = []
}

variable "management_subnets" {
  description = "list of management subnet ids"
  type = "list"
  default = []
}

variable "mgmt_security_group" {
  description = "ID of security Group to use with mgmt interface"
  default = ""
}

variable "untrust_security_group" {
  description = "ID of SG to use with public interface"
  default = ""
}

variable "trust_security_group" {
  description = "ID of SG to use w/private interface"
  default = ""
}

variable "untrust_elastic_ips" {
  description = "List of untrusted elastic ip ids"
  type = "list"
  default = []
}

variable "management_elastic_ips" {
  description = "list of mgmt elastic ip ids"
  type = "list"
  default = []
}

variable "management_elastic_ip_addresses" {
  description = "list of mgmt elastic ip addresses"
  type = "list"
  default = []
}

variable "fw_instance_count" {
  description = "number of instances to create"
  default = 1
}

variable "fw_key_name" {
  description = "SSH Public Key to use w/firewall"
  default = ""
}

variable "fw_key" {
  description = "SSH Public Key"
  default = ""
}

#AZ zones
variable "availability_zones" {
  type = "list"
  default = []
}
#AZ zone1
variable "az1" {
  default = ""
}

#Application Stackname
variable "stack_name" {
  default = ""
  description = "Generic name for application stack"
}

# select the key for auth
variable "serverkey" {
  default = ""
}
/*
# s3 bucket for bootstrapping the firewall1
variable "MasterS3Bucket" {}
variable "bootstrap1" {}
variable "bootstrap2" {}
variable "bootstrap3" {}
variable "bootstrap4" {}
*/

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

