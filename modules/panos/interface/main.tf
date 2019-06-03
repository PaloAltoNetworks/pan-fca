# Configure a bare-bones ethernet interface.
resource "panos_panorama_ethernet_interface" "static_interface" {
  count      = "${var.type == "static" ? 1 : 0}"
  name       = "${var.name}"
  template   = "${var.template}"
  vsys       = "${var.vsys}"
  mode       = "${var.mode}"
  static_ips = ["${var.static_ips}"]
  comment    = "${var.comment}"
}

# Configure a DHCP ethernet interface for vsys1 to use.
resource "panos_panorama_ethernet_interface" "dhcp_interface" {
  count                     = "${var.type == "dhcp" ? 1 : 0}"
  name                      = "${var.name}"
  template                  = "${var.template}"
  mode                      = "${var.mode}"
  enable_dhcp               = "${var.enable_dhcp}"
  create_dhcp_default_route = "${var.create_dhcp_default_route}"
  dhcp_default_route_metric = "${var.dhcp_default_route_metric}"
}

resource "panos_panorama_virtual_router_entry" "vr_static_interface" {
  depends_on     = ["panos_panorama_ethernet_interface.static_interface"]
  template       = "${var.template}"
  virtual_router = "${var.vr_name}"
  interface      = "${var.name}"
}

resource "panos_panorama_virtual_router_entry" "vr_dhcp_interface" {
  depends_on     = ["panos_panorama_ethernet_interface.dhcp_interface"]
  template       = "${var.template}"
  virtual_router = "${var.vr_name}"
  interface      = "${var.name}"
}

# Configure a bare-bones ethernet interface.
resource "panos_ethernet_interface" "fw_static_interface" {
  count      = "${var.template == "" && var.type == "static" ? 1 : 0}"
  name       = "${var.name}"
  vsys       = "${var.vsys}"
  mode       = "${var.mode}"
  static_ips = ["${var.static_ips}"]
  comment    = "${var.comment}"
}

# Configure a DHCP ethernet interface for vsys1 to use.
resource "panos_ethernet_interface" "fw_dhcp_interface" {
  count                     = "${var.template == "" && var.type == "dhcp" ? 1 : 0}"
  name                      = "${var.name}"
  mode                      = "${var.mode}"
  enable_dhcp               = "${var.enable_dhcp}"
  create_dhcp_default_route = "${var.create_dhcp_default_route}"
  dhcp_default_route_metric = "${var.dhcp_default_route_metric}"
}

resource "panos_virtual_router_entry" "vr_static_interface" {
  depends_on     = ["panos_ethernet_interface.fw_static_interface"]
  template       = "${var.template}"
  virtual_router = "${var.vr_name}"
  interface      = "${var.name}"
}

resource "panos_virtual_router_entry" "vr_dhcp_interface" {
  depends_on     = ["panos_ethernet_interface.fw_dhcp_interface"]
  virtual_router = "${var.vr_name}"
  interface      = "${var.name}"
}
