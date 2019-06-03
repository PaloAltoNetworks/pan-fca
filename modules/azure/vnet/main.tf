#Azure Generic vNet Module
# resource "azurerm_resource_group" "vnet" {
#   name     = "${var.resource_group_name}"
#   location = "${var.location}"
# }

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  location            = "${var.location}"
  address_space       = ["${var.address_space}"]
  # resource_group_name = "${azurerm_resource_group.vnet.name}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_subnet" "subnet" {
  name                      = "${var.subnet_names[count.index]}"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  # resource_group_name       = "${azurerm_resource_group.vnet.name}"
  resource_group_name       = "${var.resource_group_name}"
  address_prefix            = "${var.subnet_prefixes[count.index]}"
  count                     = "${length(var.subnet_names)}"
  #route_table_id            = "${module.router.routetable_id}"
}
