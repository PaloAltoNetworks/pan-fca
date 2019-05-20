resource "azurerm_servicebus_namespace" "pa-sb" {
  name                = "tfex_sevicebus_namespace"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "${var.servicebus_sku}"
  capacity            = "${var.servicebus_cap}"
  tags = {
    source = "${var.servicebus_tag}"
  }
}