resource "google_compute_subnetwork" "subnetwork" {
  count                    = "${length(var.subnetwork_name)}"
  name                     = "${element(var.subnetwork_name, count.index)}"
  ip_cidr_range            = "${element(var.subnetwork_cidr, count.index)}"
  network                  = "${element(var.network_self_link, count.index)}"
  region                   = "${var.region}"
  private_ip_google_access = "${var.google_access}"
}
