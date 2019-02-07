############################
# Version: 1.1             #
# Author: Torsten Stern    #
# Date: 07/25/18           #
############################

# Configure the Microsoft Azure Provider
provider "azurerm" {
    client_id         = "${var.azurerm_client_id}"
    client_secret    = "${var.azurerm_client_secret}"
    subscription_id    = "${var.azurerm_subscription_id}"
    tenant_id        = "${var.azurerm_tenant_id}"
}

# ********** RESOURCE GROUP **********

# Create a resource group
resource "azurerm_resource_group" "rgtransit" {
    name        = "${var.transitrg}"
    location    = "${var.location}"
}

# Create a Spoke resource group
resource "azurerm_resource_group" "rgspoke1" {
  name          = "${var.spoke1}"
  location      = "${var.location}"
}

# ********** VNET **********

# Create a virtual network in the resource group
# Transit VNet
resource "azurerm_virtual_network" "vnettransit" {
    name                = "${var.transitvnet}"
    address_space        = "${var.transitvnetiprange}"
    location            = "${azurerm_resource_group.rgtransit.location}"
    resource_group_name    = "${azurerm_resource_group.rgtransit.name}"
}

#Spoke VNet
resource "azurerm_virtual_network" "vnetspoke1" {
  name                = "${var.spoke1vnet}"
  address_space       = "${var.spoke1vnetiprange}"
  location            = "${azurerm_resource_group.rgtransit.location}"
  resource_group_name    = "${azurerm_resource_group.rgspoke1.name}"
}

resource "azurerm_virtual_network" "vnetspoke2" {
  name                ="${var.spoke2vnet}"
  address_space       ="${var.spoke2vnetiprange}"
  location            = "${azurerm_resource_group.rgtransit.location}"
  resource_group_name    = "${azurerm_resource_group.rgspoke1.name}"
}

# ********** SUBNETS **********
# Subnets for the Transit VNet
resource "azurerm_subnet" "Mgmt" {
  name                 = "Mgmt"
  resource_group_name  = "${azurerm_resource_group.rgtransit.name}"
  virtual_network_name = "${azurerm_virtual_network.vnettransit.name}"
  address_prefix       = "${var.mgmtsubnet}"
}

resource "azurerm_subnet" "Untrust" {
  name                 = "Untrust"
  resource_group_name  = "${azurerm_resource_group.rgtransit.name}"
  virtual_network_name = "${azurerm_virtual_network.vnettransit.name}"
  address_prefix       = "${var.untrustsubnet}"
}

resource "azurerm_subnet" "Trust" {
  name                 = "Trust"
  resource_group_name  = "${azurerm_resource_group.rgtransit.name}"
  virtual_network_name = "${azurerm_virtual_network.vnettransit.name}"
  address_prefix       = "${var.trustsubnet}"
}

resource "azurerm_subnet" "EgressLB" {
  name                 = "EgressLB"
  resource_group_name  = "${azurerm_resource_group.rgtransit.name}"
  virtual_network_name = "${azurerm_virtual_network.vnettransit.name}"
  address_prefix       = "${var.egresslbsubnet}"
}

# Subnets for the Spoke VNet
# Spoke 1
resource "azurerm_subnet" "PROD_Private-Subnet-A" {
  name                 = "PROD_Private-Subnet-A"
  resource_group_name  = "${azurerm_resource_group.rgspoke1.name}"
  virtual_network_name = "${azurerm_virtual_network.vnetspoke1.name}"
  address_prefix       = "10.217.0.0/23"
}

resource "azurerm_subnet" "PROD_Private-Subnet-B" {
  name                 = "PROD_Private-Subnet-B"
  resource_group_name  = "${azurerm_resource_group.rgspoke1.name}"
  virtual_network_name = "${azurerm_virtual_network.vnetspoke1.name}"
  address_prefix       = "10.217.2.0/23"
}

# Spoke 2
resource "azurerm_subnet" "PROD_iDMZ-Subnet-A" {
  name                 = "PROD_iDMZ-Subnet-A"
  resource_group_name  = "${azurerm_resource_group.rgspoke1.name}"
  virtual_network_name = "${azurerm_virtual_network.vnetspoke2.name}"
  address_prefix       = "10.217.4.0/23"
}

resource "azurerm_subnet" "PROD_iDMZ-Subnet-B" {
  name                 = "PROD_iDMZ-Subnet-B"
  resource_group_name  = "${azurerm_resource_group.rgspoke1.name}"
  virtual_network_name = "${azurerm_virtual_network.vnetspoke2.name}"
  address_prefix       = "10.217.6.0/23"
}

# ********** Virtual Network Peering **********
# Peering Hub to Spoke
resource "azurerm_virtual_network_peering" "hub1" {
  name                      = "${var.spoke1vnet}"
  resource_group_name       = "${azurerm_resource_group.rgtransit.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnettransit.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.vnetspoke1.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub2" {
  name                      = "${var.spoke2vnet}"
  resource_group_name       = "${azurerm_resource_group.rgtransit.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnettransit.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.vnetspoke2.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

#Peering Spoke to Hub
resource "azurerm_virtual_network_peering" "spoke1" {
  name                      = "transit-peer"
  resource_group_name       = "${azurerm_resource_group.rgspoke1.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnetspoke1.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.vnettransit.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}
resource "azurerm_virtual_network_peering" "spoke2" {
  name                      = "transit-peer"
  resource_group_name       = "${azurerm_resource_group.rgspoke1.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnetspoke2.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.vnettransit.id}"
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

# ********** STORAGE ACCOUNT **********

# Generate a random id for the storage account due to the need to be unique across azure.
# Here we are generating a random hex value of length 4 (2*2) that is prefixed with
# the static string "sternstorageaccount". For example: sternstorageaccount1n8a
resource "random_id" "storage_account" {
    prefix         = "storageaccount"
    byte_length = "2"
}

# Create the storage account
resource "azurerm_storage_account" "storrageacc" {
    name                = "${lower(random_id.storage_account.hex)}"
    resource_group_name    = "${azurerm_resource_group.rgtransit.name}"
    location            = "${azurerm_resource_group.rgtransit.location}"
    account_replication_type = "LRS"
    account_tier = "Standard"
}

# Create the storage account container
resource "azurerm_storage_container" "storagecon" {
    name                            = "vhds"
    resource_group_name                = "${azurerm_resource_group.rgtransit.name}"
    storage_account_name            = "${azurerm_storage_account.storrageacc.name}"
    container_access_type            = "private"
}

# ********** NSG for the Public IP **********

# Create NSG
resource "azurerm_network_security_group" "defaultnsg" {
  name                	= "DefaultNSG"
  location            	= "${azurerm_resource_group.rgtransit.location}"
  resource_group_name 	= "${azurerm_resource_group.rgtransit.name}"

# Create Security Rules

  security_rule {
    name                       = "Deafult-Allow-Any"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ********** VM PUBLIC IP ADDRESSES FOR MANAGEMENT **********

# Create the public IP address
resource "azurerm_public_ip" pip {
    count                            = "${var.azurerm_instances}"
    name                            = "${join("", list("FW${count.index+1}", var.fwpublicIPName, ""))}"
    location                        = "${azurerm_resource_group.rgtransit.location}"
    resource_group_name             = "${azurerm_resource_group.rgtransit.name}"
    public_ip_address_allocation    = "static"
    sku								= "Standard"
    
    tags {
     displayname = "${join("", list("PublicNetworkinterfaces", ""))}"
     }

}

# ********** VM NETWORK INTERFACES **********

# Create the network interfaces
resource "azurerm_network_interface" "Management" {
    count                                = "${var.azurerm_instances}"
    name                                = "fw-${count.index+1}-mgmt"
    location                            = "${azurerm_resource_group.rgtransit.location}"
    resource_group_name                 = "${azurerm_resource_group.rgtransit.name}"
    
    ip_configuration {
        name                            = "fw${count.index+1}-ip-0"
        subnet_id                        = "${azurerm_subnet.Mgmt.id}"
        private_ip_address_allocation     = "dynamic"
        public_ip_address_id = "${element(azurerm_public_ip.pip.*.id, count.index)}"
    }
    network_security_group_id = "${azurerm_network_security_group.defaultnsg.id}"
}

# Create the network interfaces
resource "azurerm_network_interface" "Trust" {
    count                                = "${var.azurerm_instances}"
    name                                = "fw-${count.index+1}-trust"
    location                            = "${azurerm_resource_group.rgtransit.location}"
    resource_group_name                 = "${azurerm_resource_group.rgtransit.name}"
    enable_ip_forwarding                = "true"

    ip_configuration {
        name                            = "fw${count.index+1}-ip-0"
        subnet_id                        = "${azurerm_subnet.Trust.id}"
        private_ip_address_allocation     = "dynamic"
        load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.Trust.id}"]
    }
}

# Create the network interfaces
resource "azurerm_network_interface" "Untrust" {
    count                                = "${var.azurerm_instances}"
    name                                = "fw-${count.index+1}-untrust"
    location                            = "${azurerm_resource_group.rgtransit.location}"
    resource_group_name                 = "${azurerm_resource_group.rgtransit.name}"
    enable_ip_forwarding                = "true"

    ip_configuration {
        name                            = "fw${count.index+1}-ip-0"
        subnet_id                        = "${azurerm_subnet.Untrust.id}"
        private_ip_address_allocation     = "dynamic"
        load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.Untrust.id}"]

    }
}

# ********** AVAILABILITY SET **********

# Create the availability set
resource "azurerm_availability_set" "avset" {
    name                                = "as-fw"
    location                            = "${azurerm_resource_group.rgtransit.location}"
    resource_group_name                    = "${azurerm_resource_group.rgtransit.name}"
    platform_update_domain_count = "5"
  platform_fault_domain_count  = "3"
}

# ********** STANDARD LOAD BALANCER **********

# Create the standard load balancer
resource "azurerm_lb" "lb1" {
  name                = "publicloadbalancer-1"
  location            = "${azurerm_resource_group.rgtransit.location}"
  resource_group_name = "${azurerm_resource_group.rgtransit.name}"
  sku				  = "Standard"

  frontend_ip_configuration {
    name                 			 = "Untrust"
    subnet_id                        = "${azurerm_subnet.Untrust.id}"
    private_ip_address_allocation    = "static"
	  private_ip_address 				 = "10.217.127.10"
	
  }
  frontend_ip_configuration {
    name                 			 = "Trust"
    subnet_id                        = "${azurerm_subnet.Trust.id}"
    private_ip_address_allocation    = "static"
	  private_ip_address 				 = "10.217.127.40"
	
  }
}

# Create the back end pools Trust
resource "azurerm_lb_backend_address_pool" "Trust" {
  resource_group_name = "${azurerm_resource_group.rgtransit.name}"
  loadbalancer_id     = "${azurerm_lb.lb1.id}"
  name                = "Trust"
}

# Create the back end pools Untrust
resource "azurerm_lb_backend_address_pool" "Untrust" {
  resource_group_name = "${azurerm_resource_group.rgtransit.name}"
  loadbalancer_id     = "${azurerm_lb.lb1.id}"
  name                = "Untrust"
}

resource "azurerm_lb_probe" "lb1" {
  resource_group_name = "${azurerm_resource_group.rgtransit.name}"
  loadbalancer_id     = "${azurerm_lb.lb1.id}"
  name                = "ssh-probe"
  port                = 22
    interval_in_seconds = 5
    number_of_probes    = 2
}

# Create the Load Balancing Rules
resource "azurerm_lb_rule" "Trust" {
  resource_group_name            = "${azurerm_resource_group.rgtransit.name}"
  loadbalancer_id                = "${azurerm_lb.lb1.id}"
  name                           = "Trust"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "Trust"
    backend_address_pool_id      = "${azurerm_lb_backend_address_pool.Trust.id}"
    probe_id                     = "${azurerm_lb_probe.lb1.id}"
    #load_distribution            = "Client IP and Protocol"
    enable_floating_ip           = true
  }
  
  resource "azurerm_lb_rule" "Untrust" {
  resource_group_name            = "${azurerm_resource_group.rgtransit.name}"
  loadbalancer_id                = "${azurerm_lb.lb1.id}"
  name                           = "Untrust"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "Untrust"
    backend_address_pool_id      = "${azurerm_lb_backend_address_pool.Untrust.id}"
    probe_id                     = "${azurerm_lb_probe.lb1.id}"
    #load_distribution            = "Client IP and Protocol"
    enable_floating_ip           = true
  }

# ********** VIRTUAL MACHINE CREATION **********

# Create the virtual machine. Use the "count" variable to define how many
# to create.
resource "azurerm_virtual_machine" "firewall" {
    count                       = "${var.azurerm_instances}"
    name                        = "fw-${count.index+1}"
    location                    = "${azurerm_resource_group.rgtransit.location}"
    resource_group_name         = "${azurerm_resource_group.rgtransit.name}"
    network_interface_ids =
    [
        "${element(azurerm_network_interface.Management.*.id, count.index)}",
        "${element(azurerm_network_interface.Untrust.*.id, count.index)}",
        "${element(azurerm_network_interface.Trust.*.id, count.index)}",
    ]

    primary_network_interface_id        = "${element(azurerm_network_interface.Management.*.id, count.index)}"
    vm_size                                = "${var.fw_size}"
    availability_set_id        = "${azurerm_availability_set.avset.id}"

    storage_image_reference    {
        publisher     = "${var.vm_publisher}"
        offer        = "${var.vm_series}"
        sku            = "${var.fw_sku}"
        version        = "${var.fw_version}"
    }

    plan {
        name = "${var.fw_sku}"
        product = "${var.vm_series}"
        publisher = "${var.vm_publisher}"
      }

    storage_os_disk {
        name            = "pa-vm-os-disk-${count.index+1}"
        vhd_uri            = "${azurerm_storage_account.storrageacc.primary_blob_endpoint}${element(azurerm_storage_container.storagecon.*.name, count.index)}/fwDisk${count.index+1}.vhd"
        caching         = "ReadWrite"
        create_option    = "FromImage"
    }

    delete_os_disk_on_termination    = true
    delete_data_disks_on_termination = true

    os_profile     {
        computer_name     = "pa-vm"
        admin_username    = "${var.adminUsername}"
        admin_password    = "${var.adminPassword}"
        #custom_data       = "storage-account=${var.bootstrapstorageaccount},access-key=${var.storageaccountaccesskey},file-share=${var.storageaccountfileshare},share-directory=${var.storageaccountfilesharedirectory}"
    }
    
    os_profile_linux_config {
    disable_password_authentication = false
  }
}

#### Call the Configure Script to configure the firewall ####

resource "null_resource" "configure_firewalls" {
	count								 = 2
	provisioner "local-exec" {
    command = "sh ./configure_firewall_bootstrap.sh ${var.adminUsername} ${var.adminPassword} ${element(azurerm_public_ip.pip.*.ip_address, count.index)}"
  }
	depends_on = ["azurerm_virtual_machine.firewall"]
}

# Firewall Management Public IP Outputs

output "FirewallIP-1" {
  value = "${join("", list("https://", "${azurerm_public_ip.pip.0.ip_address}"))}"
}

#output "FirewallIP-2" {
#  value = "${join("", list("https://", "${azurerm_public_ip.pip.1.ip_address}"))}"
#}
