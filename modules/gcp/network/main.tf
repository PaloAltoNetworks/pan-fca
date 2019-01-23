resource "google_compute_network" "network" {
  name                    = "${var.gcp_net_name}"
  auto_create_subnetworks = "false"
  project                 = "${var.project}"
  routing_mode            = "${var.routing_mode}"
}
