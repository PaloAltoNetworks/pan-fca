
module "os" {
  source       = "./os"
  vm_os_simple = "${var.vm_os_simple}"
}

resource "azurerm_resource_group" "vm" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
  tags     = "${var.tags}"
}

resource "random_id" "vm-sa" {
  keepers = {
    vm_hostname = "${var.vm_hostname}"
  }

  byte_length = 6
}

resource "azurerm_storage_account" "vm-sa" {
  count                    = "${var.boot_diagnostics == "true" ? 1 : 0}"
  name                     = "${var.vm_hostname}${count.index}"
  resource_group_name      = "${azurerm_resource_group.vm.name}"
  location                 = "${var.location}"
  account_tier             = "${element(split("_", var.boot_diagnostics_sa_type),0)}"
  account_replication_type = "${element(split("_", var.boot_diagnostics_sa_type),1)}"
  tags                     = "${var.tags}"
}


resource "azurerm_virtual_machine" "panw_worker_node" {
    name                  = "${var.vm_hostname}"
    location              = "${var.location}"
    resource_group_name   = "${var.resource_group_name}"
    network_interface_ids = ["${azurerm_network_interface.vm.id}"]
    vm_size               = "${var.vm_size}"

    storage_os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "${var.vm_os_publisher}"
        offer     = "${var.vm_os_simple}"
        sku       = "${var.vm_os_sku}"
        version   = "${var.vm_os_version}"
    }

    os_profile {
        computer_name  = "${var.vm_hostname}"
        admin_username = "${var.admin_username}"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = "ssh-rsa AAAAB3Nz{snip}hwhqT9h"
        }
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = "${azurerm_storage_account.vm-sa.primary_blob_endpoint}"
    }

    tags {
        environment = "Terraform Demo"
    }
}

resource "azurerm_network_interface" "vm" {
    count = "${var.nb_instances}"
    name = "nic-${var.vm_hostname}-${count.index}"
    location = "${azurerm_resource_group.vm.location}"
    resource_group_name = "${azurerm_resource_group.vm.name}"
    network_security_group_id = "${azurerm_network_security_group.vm.id}"

    ip_configuration {
        name = "ipconfig${count.index}"
        subnet_id = "${var.vnet_subnet_id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = "${length(azurerm_public_ip.vm.*.id) > 0 ? element(concat(azurerm_public_ip.vm.*.id, list("")), count.index) : ""}"
    }
}

resource "azurerm_network_security_group" "vm" {
  name                = "${var.vm_hostname}-${coalesce(var.remote_port,module.os.calculated_remote_port)}-nsg"
  location            = "${azurerm_resource_group.vm.location}"
  resource_group_name = "${azurerm_resource_group.vm.name}"

  security_rule {
    name                       = "allow_remote_${coalesce(var.remote_port,module.os.calculated_remote_port)}_in_all"
    description                = "Allow remote protocol in from all locations"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "${coalesce(var.remote_port,module.os.calculated_remote_port)}"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = "${var.tags}"
}