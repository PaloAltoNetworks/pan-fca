resource "azurerm_application_insights" "appinsight" {
  name                = "${var.appinsights_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  application_type    = "${var.appinsights_type}"
}