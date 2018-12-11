
resource "azurerm_resource_group" "vm" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

# ********** VM PUBLIC IP ADDRESSES FOR MANAGEMENT **********

# Create the public IP address
resource "azurerm_public_ip" "pip" {
    name                            = "${var.generel_int_name}$-publicIP"
    location                        = "${azurerm_resource_group.vm.location}"
    resource_group_name             = "${azurerm_resource_group.vm.name}"
    public_ip_address_allocation    = "static"
    sku								= "Standard"
    
    tags {
     displayname = "${join("", list("PublicNetworkinterfaces", ""))}"
     }
}

# ********** NSG for the Public IP **********

# Create NSG
resource "azurerm_network_security_group" "open" {
  name                	= "open"
  location            	= "${var.location}"
  resource_group_name 	= "${azurerm_resource_group.vm.name}"

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

# ********** VM NETWORK INTERFACES **********

# Create the network interfaces
resource "azurerm_network_interface" "Management" {
    name                                = "${var.generel_int_name}-PAN-Mgmt"
    location                            = "${azurerm_resource_group.vm.location}"
    resource_group_name                 = "${azurerm_resource_group.vm.name}"
    
    ip_configuration {
        name                            = "${var.generel_int_name}-ip-0"
        subnet_id                       = "${var.vnet_subnet_id_mgmt}"
        private_ip_address_allocation     = "dynamic"
        public_ip_address_id = "${element(azurerm_public_ip.pip.*.id, count.index)}"
    }
    network_security_group_id = "${azurerm_network_security_group.open.id}"
}


# ********** VIRTUAL MACHINE CREATION **********

# Create the virtual machine. Use the "count" variable to define how many
# to create.
resource "azurerm_virtual_machine" "Panorama" {
    name                          = "${var.vm_hostname}"
    location                      = "${var.location}"
    resource_group_name           = "${azurerm_resource_group.vm.name}"
    network_interface_ids         = ["${element(azurerm_network_interface.Management.*.id)}"]
    vm_size                       = "${var.fw_size}"

    delete_os_disk_on_termination = true
  
  storage_image_reference {
    publisher   = "${var.vm_publisher}"
    offer       = "${var.vm_series}"
    sku         = "${var.fw_sku}"
    version     = "${var.fw_version}"
  }
 
  plan {
    name        = "${var.fw_sku}"
    product     = "${var.vm_series}"
    publisher   = "${var.vm_publisher}"
      }

    storage_os_disk {
        name                = "pa-panorama-os-disk"
        caching             = "ReadWrite"
        create_option       = "FromImage"
        managed_disk_type   = "Premium_LRS"
    }

    delete_os_disk_on_termination    = true
    delete_data_disks_on_termination = true

    os_profile     {
        computer_name     = "pa-vm-panorma"
        admin_username    = "${var.adminUsername}"
        admin_password    = "${var.adminPassword}"
    }
    
    os_profile_linux_config {
    disable_password_authentication = false
  }
}
