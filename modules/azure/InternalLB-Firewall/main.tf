
resource "azurerm_resource_group" "vm" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
  tags     = "${var.tags}"
}

# ********** STORAGE ACCOUNT Firewall **********

# Generate a random id for the storage account due to the need to be unique across azure.
# Here we are generating a random hex value of length 4 (2*2) that is prefixed with
# the static string "sternstorageaccount". For example: sternstorageaccount1n8a
resource "random_id" "storage_account" {
    prefix         = "storageaccount"
    byte_length = "2"
}

# Create the storage account
resource "azurerm_storage_account" "storrageaccfw" {
    name                     = "${lower(random_id.storage_account.hex)}"
    resource_group_name      = "${azurerm_resource_group.vm.name}"
    location                 = "${var.location}"
    account_replication_type = "${element(split("_", var.boot_diagnostics_sa_type),1)}"
    account_tier             = "${element(split("_", var.boot_diagnostics_sa_type),0)}"
    tags                     = "${var.tags}"
}

# Create the storage account container
resource "azurerm_storage_container" "storagecon" {
    name                            = "vhds"
    resource_group_name                = "${azurerm_resource_group.vm.name}"
    storage_account_name            = "${azurerm_storage_account.storrageaccfw.name}"
    container_access_type            = "private"
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

resource "azurerm_network_security_group" "ssh" {
  name                  = "ssh"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


# ********** AVAILABILITY SET **********

# Create the availability set
resource "azurerm_availability_set" "avset" {
    name                                = "av-fw"
    location                            = "${azurerm_resource_group.vm.location}"
    resource_group_name                 = "${azurerm_resource_group.vm.name}"
    platform_update_domain_count        = 5
    platform_fault_domain_count         = 3
}

# ********** VM PUBLIC IP ADDRESSES FOR MANAGEMENT **********

# Create the public IP address
resource "azurerm_public_ip" "pip" {
    count                           = "${var.nb_instances}"
    name                            = "FW-${count.index+1}-publicIP"
    location                        = "${azurerm_resource_group.vm.location}"
    resource_group_name             = "${azurerm_resource_group.vm.name}"
    public_ip_address_allocation    = "static"
    sku								= "Standard"
    
    tags {
     displayname = "${join("", list("PublicNetworkinterfaces", ""))}"
     }
}

# ********** VM NETWORK INTERFACES **********

# Create the network interfaces
resource "azurerm_network_interface" "Management" {
    count                                = "${var.nb_instances}"
    name                                = "${var.generel_int_name}${count.index+1}${var.mgmt_int_name}"
    location                            = "${azurerm_resource_group.vm.location}"
    resource_group_name                 = "${azurerm_resource_group.vm.name}"
    
    ip_configuration {
        name                            = "${var.generel_int_name}${count.index+1}${var.mgmt_int_name}"
        subnet_id                        = "${var.vnet_subnet_id_mgmt}"
        private_ip_address_allocation     = "dynamic"
        public_ip_address_id = "${element(azurerm_public_ip.pip.*.id, count.index)}"
    }
    network_security_group_id = "${azurerm_network_security_group.open.id}"
}

# Create the network interfaces
resource "azurerm_network_interface" "Trust" {
    count                                = "${var.nb_instances}"
    name                                = "${var.generel_int_name}${count.index+1}-${var.trust_int_name}"
    location                            = "${azurerm_resource_group.vm.location}"
    resource_group_name                 = "${azurerm_resource_group.vm.name}"
    enable_ip_forwarding                = "${var.enable_ip_forwarding}"

    ip_configuration {
        name                            = "${var.generel_int_name}${count.index+1}-ip-${var.trust_int_name}"
        subnet_id                        = "${var.vnet_subnet_id_trust}"
        private_ip_address_allocation     = "dynamic"
        load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.Trust.id}"]
    }
    network_security_group_id = "${azurerm_network_security_group.open.id}"
}

# Create the network interfaces
resource "azurerm_network_interface" "Untrust" {
    count                               = "${var.nb_instances}"
    name                                = "${var.generel_int_name}${count.index+1}-${var.untrust_int_name}"
    location                            = "${azurerm_resource_group.vm.location}"
    resource_group_name                 = "${azurerm_resource_group.vm.name}"
    enable_ip_forwarding                = "${var.enable_ip_forwarding}"

    ip_configuration {
        name                                    = "${var.generel_int_name}${count.index+1}-ip-${var.untrust_int_name}"
        subnet_id                               = "${var.vnet_subnet_id_untrust}"
        private_ip_address_allocation           = "Dynamic"
    }
    network_security_group_id = "${azurerm_network_security_group.ssh.id}"
}

# ********** VIRTUAL MACHINE CREATION **********

# Create the virtual machine. Use the "count" variable to define how many
# to create.
resource "azurerm_virtual_machine" "firewall" {
    count                         = "${var.nb_instances}"
    name                          = "${var.vm_hostname}${count.index+1}"
    location                      = "${var.location}"
    resource_group_name           = "${azurerm_resource_group.vm.name}"
    network_interface_ids         = 
    [
    
        "${element(azurerm_network_interface.Management.*.id, count.index)}",
        "${element(azurerm_network_interface.Untrust.*.id, count.index)}",
        "${element(azurerm_network_interface.Trust.*.id, count.index)}",
    ]

    primary_network_interface_id  = "${element(azurerm_network_interface.Management.*.id, count.index)}"
    vm_size                       = "${var.fw_size}"
    availability_set_id           = "${azurerm_availability_set.avset.id}"
  
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
        name            = "${var.os_disk_name}${count.index+1}"
        vhd_uri            = "${azurerm_storage_account.storrageaccfw.primary_blob_endpoint}${element(azurerm_storage_container.storagecon.*.name, count.index)}/fwDisk${count.index+1}.vhd"
        caching         = "ReadWrite"
        create_option    = "FromImage"
    }

    delete_os_disk_on_termination    = true
    delete_data_disks_on_termination = true

    os_profile     {
        computer_name     = "${var.os_profile_name}"
        admin_username    = "${var.adminUsername}"
        admin_password    = "${var.adminPassword}"
    }
    
    os_profile_linux_config {
    disable_password_authentication = false
  }
}
#### Call the Configure Script to configure the firewall ####

resource "null_resource" "configure_firewalls" {
	count								 = 2
	provisioner "local-exec" {
    command = "echo '${element(azurerm_public_ip.pip.*.ip_address, count.index)}' > fw_ip.txt"
  }
	depends_on = ["azurerm_virtual_machine.firewall"]
}