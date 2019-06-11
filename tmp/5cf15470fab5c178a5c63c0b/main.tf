
module "AzureSpoke1" {
  source                  = "../../core/modules/azure/vnet"
  resource_group_name     = "AzureSpoke1"
  location                = "West US"
  vnet_name               = "SternTransitVNet1"
  address_space           = "10.217.130.0/24"
  subnet_prefixes         = ["10.217.130.64/27","10.217.130.32/27","10.217.130.0/27"]
  subnet_names            = ["Management","Trust","Untrust"]



}

module "AzureHUB1" {
  source                  = "../../core/modules/azure/vnet"
  resource_group_name     = "AzureHUB1"
  location                = "West US"
  vnet_name               = "TorstenWebVNet1"
  address_space           = "172.16.130.0/24"
  subnet_prefixes         = ["172.16.130.0/26","172.16.130.64/26","172.16.130.128/26"]
  subnet_names            = ["Webserver","DB","Test"]



}
      
module "External-LB" {
  source                                 = "../../core/modules/azure/loadbalancer"
  name                                   = "External-LB"
  location                               = "West US"
  resource_group_name                    = "AzureSpoke1"
  type                                   = "public"
  
  

  frontend_name                          = "Untrust"
  backendpoolname                        = "Untrust"
  lb_probename                           = "TCP-22"

  

  "lb_port" {
      TCP-22  = ["22", "tcp", "22"]
  }

  "lb_probe_port" {
      TCP-22 = ["22"]
  }
}
      
module "Internal-LB" {
  source                                 = "../../core/modules/azure/loadbalancer"
  name                                   = "Internal-LB"
  location                               = "West US"
  resource_group_name                    = "AzureSpoke1"
  type                                   = "private"
  
  

  frontend_name                          = "Trust"
  backendpoolname                        = "Trust"
  lb_probename                           = "ssh"

  frontend_subnet_id                     = "${module.AzureSpoke1.vnet_subnets[1]}" 
    
    frontend_private_ip_address            = "${cidrhost(module.AzureSpoke1.vnet_subnet_prefixes[1], -3)}"
    

  "lb_port" {
      HA  = ["0", "All", "0"]
  }

  "lb_probe_port" {
      ssh = ["22"]
  }
}

module "AzureAV" {
  source                      = "../../core/modules/azure/firewall"
  resource_group_name         = "AzureSpoke1"
  location                    = "West US"
  nb_instances                = "2"
  
  
  
  
  
  
  
   
  vnet_subnet_id_mgmt         = "${module.AzureSpoke1.vnet_subnets[0]}"
  vnet_subnet_id_trust        = "${module.AzureSpoke1.vnet_subnets[1]}"
  vnet_subnet_id_untrust      = "${module.AzureSpoke1.vnet_subnets[2]}"

  fw_hostname                 = "TSVMPAN-"
  fw_size                     = "Standard_D3_v2"
  avsetname                   = "AzureAV"
}

module "AzureSpoke1_peer_0" {
  source                               = "../../core/modules/azure/peering"
  peer_name                            = "${module.AzureSpoke1.vnet_name}"
  peer_name                            = "${module.AzureSpoke1.vnet_name}"
  peer_resource_group_name             = "${module.AzureSpoke1.resource_group_name}"
  peer_virtual_network_name            = "${module.AzureSpoke1.vnet_name}"
  peer_remote_virtual_network_id       = "${module.AzureSpoke1.vnet_id}"
}


module "AzureHUB1-web-test" {
  source                               = "../../core/modules/azure/router"
  location                             = "West US"
  resource_group_name                  = "${module.AzureHUB1.resource_group_name}"
  route_table_name                     = "web-test"

  routes = [
    {
        name    = "VirtualAppliance"
        cidr    = "0.0.0.0/0"
        gateway = "10.217.130.61"
        name    = "VirtualAppliance"

        
      }
  ]
}

