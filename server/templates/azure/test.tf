
module "AzureHUB" {
  source                  = "../../../core/modules/azure/vnet"
  resource_group_name     = "AzureHUB"
  location                = "West US"
  vnet_name               = "SternTransitVNet"
  address_space           = "10.217.130.0/24"
  subnet_prefixes         = ["10.217.130.64/27","10.217.130.32/27","10.217.130.0/27"]
  subnet_names            = ["Management","Trust","Untrust"]
}

module "AzureSpoke" {
  source                  = "../../../core/modules/azure/vnet"
  resource_group_name     = "AzureSpoke"
  location                = "West US"
  vnet_name               = "TorstenWebVNet"
  address_space           = "172.16.130.0/24"
  subnet_prefixes         = ["172.16.130.0/26","172.16.130.64/26","172.16.130.128/26"]
  subnet_names            = ["Webserver","DB","Test"]



}
      
module "External-LB" {
  source                                 = "../../../core/modules/azure/loadbalancer"
  name                                   = "External-LB"
  location                               = "West US"
  resource_group_name                    = "AzureHUB"
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
  source                                 = "../../../core/modules/azure/loadbalancer"
  name                                   = "Internal-LB"
  location                               = "West US"
  resource_group_name                    = "AzureHUB"
  type                                   = "private"
  
  

  frontend_name                          = "Trust"
  backendpoolname                        = "Trust"
  lb_probename                           = "ssh"

  frontend_subnet_id                     = "${module.AzureHUB.vnet_subnets[1]}" 
    
    frontend_private_ip_address            = "${cidrhost(module.AzureHUB.vnet_subnet_prefixes[1], -3)}"
    

  "lb_port" {
      HA  = ["0", "All", "0"]
  }

  "lb_probe_port" {
      ssh = ["22"]
  }
}

module "AzureAV" {
  source                      = "../../../core/modules/azure/firewall"
  resource_group_name         = "AzureHUB"
  location                    = "West US"
  nb_instances                = "2"
  
  
  
  
  
  
  
   
  vnet_subnet_id_mgmt         = "${module.AzureHUB.vnet_subnets[0]}"
  vnet_subnet_id_trust        = "${module.AzureHUB.vnet_subnets[1]}"
  vnet_subnet_id_untrust      = "${module.AzureHUB.vnet_subnets[2]}"

  fw_hostname                 = "TSVMPAN-"
  fw_size                     = "Standard_D3_v2"
  avsetname                   = "AzureAV"
}

module "AzureHUB_peer_0" {
  source                               = "../../../core/modules/azure/peering"
  peer_name                            = "${module.AzureSpoke.vnet_name}"
  peer_name                            = "${module.AzureSpoke.vnet_name}"
  peer_resource_group_name             = "${module.AzureSpoke.resource_group_name}"
  peer_virtual_network_name            = "${module.AzureSpoke.vnet_name}"
  peer_remote_virtual_network_id       = "${module.AzureSpoke.vnet_id}"
}


module "AzureSpoke-web-test" {
  source                               = "../../../core/modules/azure/router"
  location                             = "West US"
  resource_group_name                  = "${module.AzureSpoke.resource_group_name}"
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


module "AzureSpoke-Test-VM" {
  source                    = "../../../core/modules/azure/testhost"
  location                  = "West US"
  resource_group_name       = "AzureSpoke"
  vnet_subnet_id_vm         = "${module.AzureSpoke.vnet_subnets[0]}"
  hostname                  = "Test-VM"
  admin_username            = "creator"
  admin_password            = "Paloalto123456789"
  dns_name                  = "ubuntutestvm2"
}