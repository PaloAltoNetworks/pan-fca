resource "vsphere_drs_vm_override" "drs_vm_override" {
  compute_cluster_id = "${var.compute_cluster_id}"
  virtual_machine_id = "${var.virtual_machine_id}"
  drs_enabled        = "${var.drs_enabled}"
}