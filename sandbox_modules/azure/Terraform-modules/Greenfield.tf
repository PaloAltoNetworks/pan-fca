module "Stern-Test" {
  source              = "./modules/vnet"
  resource_group_name = "${var.resource_group_name}"
  location            = "${ var.location }"
  vnet_name           = "mainvnet"
  address_space       = "10.217.127.0/24"
  subnet_prefixes     = ["10.217.127.64/27", "10.217.127.32/27", "10.217.127.0/27", "10.217.127.96/27"]
  subnet_names        = ["Management", "Trust", "Untrust", "EgressLB"]
}

module "Operations" {
  source              = "./modules/vnet"
  resource_group_name = "Operations"
  location            = "${ var.location }"
  vnet_name           = "VNetA"
  address_space       = "192.168.1.0/24"
  subnet_prefixes     = ["192.168.1.0/25", "192.168.1.128/25"]
  subnet_names        = ["SubA", "SubAA"]
}

module "Security" {
  source              = "./modules/vnet"
  resource_group_name = "Security"
  location            = "${ var.location }"
  vnet_name           = "VNetB"
  address_space       = "192.168.2.0/24"
  subnet_prefixes     = ["192.168.2.0/25", "192.168.2.128/25"]
  subnet_names        = ["SubB", "SubBB"]
}

module "loadbalancer" {
  source                                 = "./modules/loadbalancer"
  name                                   = "Private-LB"
  location                               = "${var.location}"
  resource_group_name                    = "${var.resource_group_name}"
  type                                   = "private"
  frontend_name                          = "Trust"
  frontend_subnet_id                     = "${module.Stern-Test.vnet_subnets[1]}"
  frontend_private_ip_address_allocation = "Static"
  frontend_private_ip_address            = "${var.frontend_private_ip_address}"
  backendpoolname                        = "Trust"

  "remote_port" {
    ssh = ["Tcp", "22"]
  }

  "lb_port" {
    http = ["0", "All", "0"]

    #https = ["443", "Tcp", "443"]
  }

  "lb_probe_port" {
    http = ["22"]
  }
}

#Creating Public Load Balancer
module "Public-Loadbalancer" {
  source              = "./modules/loadbalancer"
  name                = "Public-LB"
  resource_group_name = "${var.resource_group_name}"
  type                = "public"
  location            = "${var.location}"
  frontend_name       = "Untrust"
  backendpoolname     = "Untrust"

  "remote_port" {
    ssh = ["Tcp", "22"]
  }

  "lb_port" {
    http = ["80", "Tcp", "80"]
  }

  "lb_probe_port" {
    http = ["22"]
  }
}

# Creating the Palo Alto Firewalls

module "firewall" {
  source                  = "./modules/firewall"
  location                = "${var.location}"
  resource_group_name     = "${var.resource_group_name}"
  vnet_subnet_id_trust    = "${module.Stern-Test.vnet_subnets[1]}"
  vnet_subnet_id_untrust  = "${module.Stern-Test.vnet_subnets[2]}"
  vnet_subnet_id_mgmt     = "${module.Stern-Test.vnet_subnets[0]}"
  lb_backend_pool_trust   = "${module.loadbalancer.azurerm_lb_backend_address_pool_id}"
  lb_backend_pool_untrust = "${module.Public-Loadbalancer.azurerm_lb_backend_address_pool_id}"
  #lb_backend_pool_untrust = "${var.publicloadbalancer == "1" ? "${module.Public-Loadbalancer.azurerm_lb_backend_address_pool_id}" : ""}"

}


# Creating VNet Peering

module "hub_peer" {
  source                          = "./modules/peering"
  spoke_peer_name                 = "VNetA"
  resource_group_name             = "${module.Stern-Test.resource_group_name}"
  virtual_network_name            = "${module.Stern-Test.vnet_name}"
  remote_virtual_network_id       = "${module.Operations.vnet_id}"
  virtual_network_access          = "true"
  forwarded_traffic               = "true"
  gateway_transit                 = "false"
  remote_gateways                 = "false"
}

module "hub_peer2" {
  source                          = "./modules/peering"
  spoke_peer_name                 = "VNetB"
  resource_group_name             = "${module.Stern-Test.resource_group_name}"
  virtual_network_name            = "${module.Stern-Test.vnet_name}"
  remote_virtual_network_id       = "${module.Security.vnet_id}"
  virtual_network_access          = "true"
  forwarded_traffic               = "true"
  gateway_transit                 = "false"
  remote_gateways                 = "false"
}

module "spoke_peer" {
  source                          = "./modules/peering"
  spoke_peer_name                 = "Transit-Peer"
  resource_group_name             = "${module.Operations.resource_group_name}"
  virtual_network_name            = "${module.Operations.vnet_name}"
  remote_virtual_network_id       = "${module.Stern-Test.vnet_id}"
  virtual_network_access          = "true"
  forwarded_traffic               = "true"
  gateway_transit                 = "true"
  remote_gateways                 = "false"
}

module "spoke_peer2" {
  source                          = "./modules/peering"
  spoke_peer_name                 = "Transit-Peer"
  resource_group_name             = "${module.Security.resource_group_name}"
  virtual_network_name            = "${module.Security.vnet_name}"
  remote_virtual_network_id       = "${module.Stern-Test.vnet_id}"
  virtual_network_access          = "true"
  forwarded_traffic               = "true"
  gateway_transit                 = "true"
  remote_gateways                 = "false"

}

# Creating Routing

module "route_spoke" {
  source                = "./modules/router"
  location              = "${var.location}"
  route_table_name      = "${var.route_table_name}"
  resource_group_name   = "Operations"
  route_name            = "${var.route_name}"
  address_prefix_route  = "${var.address_prefix_route}"
  next_hop_type         = "${var.next_hop_type}"
  next_hop_ip           = "${var.frontend_private_ip_address}"

}

module "route_spoke2" {
  source                = "./modules/router"
  location              = "${var.location}"
  route_table_name      = "${var.route_table_name}"
  resource_group_name   = "Security"
  route_name            = "${var.route_name}"
  address_prefix_route  = "${var.address_prefix_route}"
  next_hop_type         = "${var.next_hop_type}"
  next_hop_ip           = "${var.frontend_private_ip_address}"
}

