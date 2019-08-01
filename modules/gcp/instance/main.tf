resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

resource "google_compute_instance" "instance" {
  count                     = "${var.instance_type == "firewall" ? var.nb_instances : 0}"
  name                      = "${element(var.instance_name,count.index)}"
  machine_type              = "${var.machine_type}"
  zone                      = "${element(var.zone,count.index)}"
  min_cpu_platform          = "${var.machine_cpu}"
  can_ip_forward            = "${var.enable_ip_forward}"
  allow_stopping_for_update = "${var.allow_stop_for_update}"

  // Adding METADATA Key Value pairs to VM-Series GCE instance
  metadata {
    vmseries-bootstrap-gce-storagebucket = "${var.bootstrap_bucket}"
    serial-port-enable                   = true
    mgmt-interface-swap                  = "${var.int_swap}"
    ssh-keys                             = "${var.public_key}"
  }

  service_account {
    scopes = "${var.scopes}"
  }

  network_interface {
    subnetwork    = "${var.untrust-sub_self_link}"
    access_config = {}
    network_ip    = "${element(var.fw_nic0_ip, count.index)}"
  }

  network_interface {
    subnetwork    = "${var.management-sub_self_link}"
    access_config = {}
    network_ip    = "${element(var.fw_nic1_ip, count.index)}"
  }

  network_interface {
    subnetwork = "${var.trust-sub_self_link}"
    network_ip    = "${element(var.fw_nic2_ip, count.index)}"
  }

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }
  depends_on = ["null_resource.dependency_getter"]
}

resource "google_compute_instance" "webserver" {
  count                     = "${var.instance_type != "firewall" ? var.nb_instances : 0}"
  name                      = "${element(var.instance_name, count.index)}"
  machine_type              = "${var.machine_type_web}"
  zone                      = "${element(var.zone, count.index)}"
  allow_stopping_for_update = "${var.allow_stop_for_update}"

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    subnetwork = "${var.trust-sub_self_link}"
  }

  service_account {
    scopes = ["${var.scopes}"]
  }
}


resource "google_compute_instance_group" "vmseries" {
  count     = "${(var.create_instance_group) ? length(var.instance_name) : 0}"
  name      = "${element(var.instance_group_names, count.index)}"
  zone      = "${element(var.zone, count.index)}"
  instances = ["${google_compute_instance.instance.*.self_link[count.index]}"]

  named_port {
    name = "${var.port_name}"
    port = "${var.port}"
  }
}