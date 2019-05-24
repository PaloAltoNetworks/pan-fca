resource "google_compute_instance" "instance" {
  count                     = "${var.nb_instances}"
  name                      = "${var.instance_name}-${count.index + 1}"
  machine_type              = "${var.machine_type}"
  zone                      = "${var.zone}"
  min_cpu_platform          = "${var.machine_cpu}"
  can_ip_forward            = "${var.enable_ip_forward}"
  allow_stopping_for_update = "${var.allow_stop_for_update}"

  // Adding METADATA Key Value pairs to VM-Series GCE instance
  metadata {
    vmseries-bootstrap-gce-storagebucket = "${var.bootstrap_bucket}"
    serial-port-enable                   = true

    # sshKeys                              = "${var.public_key}"
  }

  service_account {
    scopes = "${var.scopes}"
  }

  network_interface {
    subnetwork    = "${var.management-sub_self_link}"
    access_config = {}
  }

  network_interface {
    subnetwork    = "${var.untrust-sub_self_link}"
    access_config = {}
  }

  network_interface {
    subnetwork = "${var.trust-sub_self_link}"
  }

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }
}
