# ********** Virtual Network Peering **********
# Peering Hub to Spoke

resource "azurerm_virtual_network_peering" "peer" {
  name                         = "${var.peer_name}"
  resource_group_name          = "${var.resource_group_name}"
  virtual_network_name         = "${var.peer_virtual_network_name}"
  remote_virtual_network_id    = "${var.peer_remote_virtual_network_id}"
  allow_virtual_network_access = "${var.allow_virtual_network_access}"
  allow_forwarded_traffic      = "${var.allow_forwarded_traffic}"
  allow_gateway_transit        = "${var.allow_gateway_transit}"
  use_remote_gateways          = "${var.use_remote_gateways}"
}
