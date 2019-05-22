resource "google_compute_subnetwork" "subnetwork" {
  name          = "${var.subnetwork_name}"
  ip_cidr_range = "${var.subnetwork_cidr}"
  network       = "${var.network_self_link}"
  region        = "${var.region}"
  private_ip_google_access = "${var.google_access}"
}