output hub_peering_id {
value = "${azurerm_virtual_network_peering.hub.*.id}"
}
