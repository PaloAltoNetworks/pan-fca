resource "google_compute_firewall" "management" {
  count   = "${var.type == "mgmt" ? 1 : 0 }"
  name    = "${var.gcp_fw_name}"
  network = "${var.google_compute_network}"

  //  disabled = "${var.gcp_fw_disable == true ? true : false}"
  //  enable_logging = "${var.gcp_fw_logging}"
  priority = "${var.priority}"

  allow {
    protocol = "${var.allow_ping == true ? "icmp" : ""}"
  }

  allow {
    protocol = "${var.allow_proto}"
    ports    = ["${var.allow_ports}"]
  }

//  source_tags   = ["${var.allow_tags}"]
  source_ranges = ["${var.allow_source_ranges}"]
}

resource "google_compute_firewall" "untrust" {
  count   = "${var.type == "untrust" ? 1 : 0}"
  name    = "${var.gcp_fw_name}"
  network = "${var.google_compute_network}"

  //  disabled = "${var.gcp_fw_disable == true ? true : false}"
  //  enable_logging = "${var.gcp_fw_logging}"
  priority = "${var.priority}"

  allow {
    protocol = "all"
  }

//  source_tags   = ["${var.allow_tags}"]
  source_ranges = ["${var.allow_source_ranges}"]
}

resource "google_compute_firewall" "trust" {
  count   = "${var.type == "trust" ? 1 : 0}"
  name    = "${var.gcp_fw_name}"
  network = "${var.google_compute_network}"

  //  disabled = "${var.gcp_fw_disable == true ? true : false}"
  //  enable_logging = "${var.gcp_fw_logging}"
  priority = "${var.priority}"

  allow {
    protocol = "all"
  }

//  source_tags   = ["${var.allow_tags}"]
  source_ranges = ["${var.allow_source_ranges}"]
}
