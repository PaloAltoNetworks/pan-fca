resource "google_compute_network" "network" {
  count                   = "${length(var.gcp_net_name)}"
  name                    = "${element(var.gcp_net_name, count.index)}"
  auto_create_subnetworks = "false"
  project                 = "${var.project}"
  routing_mode            = "${var.routing_mode}"
}
