module "terraform-azurerm-vnet" {
  vnet_name           = "${var.vnet_name}"
  location            = "${var.location}"
  address_space       = "${var.address_space}"
  resource_group_name = "${var.resource_group_name}"
}