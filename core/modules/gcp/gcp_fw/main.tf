resource "google_compute_firewall" "fw-custom" {
  count = "${var.allow_all && true ? 0 : 1}"
  name    = "${var.gcp_fw_name}"
  network = "${var.google_compute_network}"
  disabled = "${var.gcp_fw_disable == true ? true : false}"
  enable_logging = "${var.gcp_fw_logging == true ? true : false}"
  priority = "${var.priority}"

  allow {
    protocol = "${var.allow_ping == true ? "icmp" : ""}"
  }

  allow {
    protocol = "${var.allow_proto}"
    //ports    = ["443", "22"]
    ports = ["${var.allow_ports}"]
  }
  //source_ranges = ["0.0.0.0/0"]
  source_tags   = ["${var.allow_tags}"]
  source_ranges = ["${var.allow_source_ranges}"]
}

resource "google_compute_firewall" "fw-all" {
  count = "${var.allow_all && true ? 1 : 0}"
  name    = "${var.gcp_fw_name}"
  network = "${var.google_compute_network}"
  disabled = "${var.gcp_fw_disable == true ? true : false}"
  enable_logging = "${var.gcp_fw_logging == true ? true : false}"
  priority = "${var.priority}"

  allow {
    protocol = "all"
  }
  //source_ranges = ["0.0.0.0/0"]
  source_tags   = ["${var.allow_tags}"]
  source_ranges = ["${var.allow_source_ranges}"]
}