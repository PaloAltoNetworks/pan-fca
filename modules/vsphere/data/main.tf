/* == VSPHERE CONFIGURATION ================================================= */
data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "management" {
  name          = "${var.vsphere_network_management}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "untrust" {
  name          = "${var.vsphere_network_untrust}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "trust" {
  name          = "${var.vsphere_network_trust}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template_from_ovf" {
  name          = "${var.vsphere_template_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}