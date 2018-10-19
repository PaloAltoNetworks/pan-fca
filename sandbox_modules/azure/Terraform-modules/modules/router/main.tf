
resource "azurerm_resource_group" "route" {
    name     = "${var.resource_group_name}"
    location = "${var.location}"
}

resource "azurerm_route_table" "route_table" {
  name                = "${var.route_table_name}"
  location            = "${azurerm_resource_group.route.location}"
  resource_group_name = "${azurerm_resource_group.route.name}"
}

resource "azurerm_route" "route_entry" {
  name                      = "${var.route_name}"
  resource_group_name       = "${azurerm_resource_group.route.name}"
  route_table_name          = "${var.route_table_name}"
  address_prefix            = "${var.address_prefix_route}"
  next_hop_type             = "${var.next_hop_type}"
  next_hop_in_ip_address    = "${var.next_hop_ip}"
}


/*
#Routing Example to the internal FrontendIP of the Internal LB
# Spoke Route Tabel

resource "azurerm_route_table" "Spoke" {
  name                = "RT-${var.spokevnet}"
  location            = "${azurerm_resource_group.rgspoke.location}"
  resource_group_name = "${azurerm_resource_group.rgspoke.name}"

disable_bgp_route_propagation = false

  route {
    name           = "default"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "${var.frontendip_internallb}"
  }
}
*/