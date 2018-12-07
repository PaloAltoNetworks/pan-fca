/*
output hub_peering_id {
value = "${azurerm_virtual_network_peering.hub.id}"
}

output spoke_peering_id {
value = "${azurerm_virtual_network_peering.spoke.id}"
}
*/
output peering_id {
value = "${azurerm_virtual_network_peering.peer.id}"
}

