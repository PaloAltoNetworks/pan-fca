resource "google_compute_route" "trust-nextinstance" {
  count                  = "${var.instance_name != "" ? 1 : 0}"
  name                   = "${var.route_name}"
  dest_range             = "${var.dest_range}"
  network                = "${var.network_self_link}"
  next_hop_instance      = "${element(var.instance_name,count.index)}"
  next_hop_ip = "${var.instance_name}"
  next_hop_instance_zone = "${var.zone}"
  priority               = "${var.priority}"
}


resource "google_compute_route" "trust-nextip" {
  count                  = "${var.next_hop_ip != "" ? 1 : 0}"
  name                   = "${var.route_name}"
  dest_range             = "${var.dest_range}"
  network                = "${var.network_self_link}"
  next_hop_ip = "${var.next_hop_ip}"
  priority               = "${var.priority}"
}