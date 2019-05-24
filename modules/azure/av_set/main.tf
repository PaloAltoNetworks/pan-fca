# Create the availability set
resource "azurerm_availability_set" "avset" {
    name                                = "${var.avsetname}"
    location                            = "${var.location}"
    resource_group_name                 = "${var.resource_group_name}"
    platform_update_domain_count        = 5
    platform_fault_domain_count         = 3
}
