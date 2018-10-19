# ********** Virtual Network Peering **********
# Total Peering


resource "azurerm_virtual_network_peering" "hub" {
  name                         = "${var.spoke_peer_name}"
  resource_group_name          = "${var.resource_group_name}"
  virtual_network_name         = "${var.virtual_network_name}"
  remote_virtual_network_id    = "${var.remote_virtual_network_id}"
  allow_virtual_network_access = "${var.virtual_network_access}"
  allow_forwarded_traffic      = "${var.forwarded_traffic}"
  allow_gateway_transit        = "${var.gateway_transit}"
  use_remote_gateways          = "${var.remote_gateways}"
}
