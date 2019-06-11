provider "vsphere" {
  user                 = "administrator@vsphere.local"
  password             = "VMware01!"
  vsphere_server       = "192.168.100.100"
  allow_unverified_ssl = true                          # If you have a self-signed cert
}

module "data" {
  source                     = "../../modules/vsphere/data"
  vsphere_datacenter         = "Datacenter"
  vsphere_datastore          = "Datastore"
  vsphere_cluster            = "Cluster"
  vsphere_network_management = "VM Network"
  vsphere_network_trust      = "VM Network"
  vsphere_network_untrust    = "VM Network"
}

module "virtual_machine" {
  source             = "../../modules/vsphere/virtual_machine"
  name               = "myfirewall"
  resource_pool_id   = "${module.data.resource_pool_id}"
  datastore_id       = "${module.data.datastore_id}"
  num_cpus           = "2"
  management_id      = "${module.data.network_mgmt_id}"
  network_untrust_id = "${module.data.network_untrust_id}"
  network_trust_id   = "${module.data.network_trust_id}"
  template_uuid      = "${module.data.template_uuid}"
}

module "disable_drs" {
  source = "../../modules/vsphere/drs_override"
  drs_enabled = false
  compute_cluster_id = "${module.data.cluster_id}"
  virtual_machine_id = "${module.virtual_machine.vm_id}"
}
