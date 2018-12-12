# ********** Virtual Network Peering **********
# Peering Hub to Spoke

resource "azurerm_virtual_network_peering" "peer" {
  name                      = "${var.peer_name}"
  resource_group_name       = "${var.peer_resource_group_name}"
  virtual_network_name      = "${var.peer_virtual_network_name}"
  remote_virtual_network_id = "${var.peer_remote_virtual_network_id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
/*
#Peering Spoke to Hub
resource "azurerm_virtual_network_peering" "spoke" {
  name                      = "transit-peer"
  resource_group_name       = "${var.peer_resource_group_name}"
  virtual_network_name      = "${var.peer_virtual_network_name}"
  remote_virtual_network_id = "${var.peer_remote_virtual_network_id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}
*/
