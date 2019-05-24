
# resource "azurerm_resource_group" "route" {
#     name     = "${var.resource_group_name}"
#     location = "${var.location}"
# }

resource "azurerm_route_table" "route_table" {
  name                = "${var.route_table_name}"
  location            = "${var.location}"
  # resource_group_name = "${azurerm_resource_group.route.name}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_route" "route_entry" {
  count                     = "${length(var.routes)}"
  name                      = "${lookup(var.routes[count.index], "name")}"
  # resource_group_name       = "${azurerm_resource_group.route.name}"
  resource_group_name       = "${var.resource_group_name}"
  route_table_name          = "${var.route_table_name}"
  address_prefix            = "${lookup(var.routes[count.index], "cidr")}"
  next_hop_type             = "${lookup(var.routes[count.index], "next_hop_type", "VirtualAppliance")}"
  next_hop_in_ip_address    = "${lookup(var.routes[count.index], "gateway")}"
  depends_on = ["azurerm_route_table.route_table"]
}
