resource "panos_panorama_static_route_ipv4" "pano_nexthopip" {
  count          = "${var.template != "" && var.type == "ip-address" ? 1 : 0 }"
  name           = "${var.name}"
  virtual_router = "${var.vr_name}"
  template       = "${var.template}"
  destination    = "${var.destination}"
  next_hop       = "${var.next_hop}"
  type           = "${var.type}"
}

resource "panos_panorama_static_route_ipv4" "pano_nexthopvr" {
  count          = "${var.template != "" && var.type == "next-vr" ? 1 : 0 }"
  name           = "${var.name}"
  virtual_router = "${var.vr_name}"
  template       = "${var.template}"
  destination    = "${var.destination}"
  next_hop       = "${var.next_hop}"
  type           = "${var.type}"
}

resource "panos_static_route_ipv4" "pano_nexthopip" {
  count          = "${var.template == "" && var.type == "ip-address" ? 1 : 0 }"
  name           = "${var.name}"
  virtual_router = "${var.vr_name}"
  destination    = "${var.destination}"
  next_hop       = "${var.next_hop}"
  type           = "${var.type}"
}

resource "panos_static_route_ipv4" "pano_nexthopvr" {
  count          = "${var.template == "" && var.type == "next-vr" ? 1 : 0 }"
  name           = "${var.name}"
  virtual_router = "${var.vr_name}"
  destination    = "${var.destination}"
  next_hop       = "${var.type}"
  type           = "${var.type}"
}