output "datastore_id" {
  value = "${data.vsphere_datastore.datastore.id}"
}

output "cluster_id" {
  value = "${data.vsphere_compute_cluster.cluster.*.id}"
}

output "dc_id" {
  value = "${data.vsphere_datacenter.dc.*.id}"
}

output "network_mgmt_id" {
  value = "${data.vsphere_network.management.*.id}"
}

output "network_untrust_id" {
  value = "${data.vsphere_network.untrust.*.id}"
}

output "network_trust_id" {
  value = "${data.vsphere_network.trust.*.id}"
}

output "template_uuid" {
  value = "${data.vsphere_virtual_machine.template_from_ovf.*.id}"
}

output "resource_pool_id" {
  value = "${data.vsphere_compute_cluster.cluster.*.resource_pool_id}"
}