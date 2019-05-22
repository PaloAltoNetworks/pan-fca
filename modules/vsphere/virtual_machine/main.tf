resource "vsphere_virtual_machine" "vm" {
  name                       = "${var.name}"
  resource_pool_id           = "${var.resource_pool_id}"
  datastore_id               = "${var.datastore_id}"
  num_cpus                   = "${var.num_cpus}"
  memory                     = "${var.memory}"
  guest_id                   = "${var.guest_id}"
  scsi_type                  = "${var.scsi_type}"
  wait_for_guest_ip_timeout  = "${var.wait_for_guest_ip_timeout}"
  wait_for_guest_net_timeout = "${var.wait_for_guest_net_timeout}"

  network_interface {
    network_id   = "${var.management_id}"
    adapter_type = "${var.adapter_type}"
  }
  network_interface {
    network_id   = "${var.network_untrust_id}"
    adapter_type = "${var.adapter_type}"
  }
  network_interface {
    network_id   = "${var.network_trust_id}"
    adapter_type = "${var.adapter_type}"
  }

  cdrom {
    client_device = "${var.cdrom_client_device}"
  }

  disk {
    label = "disk0"
    size  = "${var.disk_size}"
  }

  clone {
    template_uuid = "${var.template_uuid}"
  }
}