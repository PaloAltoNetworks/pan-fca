# resource "azurerm_resource_group" "vm" {
#   name     = "${var.resource_group_name}"
#   location = "${var.location}"
#   tags     = "${var.tags}"
# }

# ********** VM PUBLIC IP ADDRESSES FOR MANAGEMENT **********

# Create the public IP address
resource "azurerm_public_ip" "pip" {
  name                         = "${var.hostname}-PIP"
  location                     = "${var.location}"
  # resource_group_name          = "${azurerm_resource_group.vm.name}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "Dynamic"
  #domain_name_label            = "${var.dns_name}"
}


# ********** VM NETWORK INTERFACES **********

# Create the network interfaces
resource "azurerm_network_interface" "nic" {
  name                = "${var.hostname}-NIC"
  location            = "${var.location}"
  # resource_group_name = "${azurerm_resource_group.vm.name}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "${var.hostname}-NIC-IP"
    subnet_id                     = "${var.vnet_subnet_id_vm}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pip.id}"
  }
}

# ********** STORAGE ACCOUNT VM **********
# Generate a random id for the storage account due to the need to be unique across azure.
# Here we are generating a random hex value of length 4 (2*2) that is prefixed with
# the static string "sternstorageaccount". For example: sternstorageaccount1n8a
resource "random_id" "storage_account" {
    prefix         = "storageaccount"
    byte_length = "2"
}

# Create the storage account
resource "azurerm_storage_account" "stor" {
  name                     = "${lower(random_id.storage_account.hex)}"
  location                 = "${var.location}"
  # resource_group_name      = "${azurerm_resource_group.vm.name}"
  resource_group_name      = "${var.resource_group_name}"
  account_tier             = "${var.storage_account_tier}"
  account_replication_type = "${var.storage_replication_type}"
}

# Create the storage account container
resource "azurerm_storage_container" "storagecon" {
    name                            = "vhds"
    # resource_group_name             = "${azurerm_resource_group.vm.name}"
    resource_group_name             = "${var.resource_group_name}"
    storage_account_name            = "${azurerm_storage_account.stor.name}"
    container_access_type           = "private"
}

# ********** DATADISK VM **********

# Create the managed disk
resource "azurerm_managed_disk" "datadisk" {
  name                 = "${var.hostname}-datadisk"
  location             = "${var.location}"
  # resource_group_name  = "${azurerm_resource_group.vm.name}"
  resource_group_name = "${var.resource_group_name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
}

# ********** VIRTUAL MACHINE CREATION **********

# Create the virtual machine.

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.hostname}"
  location              = "${var.location}"
  # resource_group_name   = "${azurerm_resource_group.vm.name}"
  resource_group_name   = "${var.resource_group_name}"
  vm_size               = "${var.vm_size}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }

  plan {
    name      = "${var.image_sku}"
    publisher = "${var.image_publisher}"
    product   = "${var.image_offer}"
  }

  storage_os_disk {
    name              = "${var.hostname}-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  storage_data_disk {
    name              = "${var.hostname}-datadisk"
    managed_disk_id   = "${azurerm_managed_disk.datadisk.id}"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "1023"
    create_option     = "Attach"
    lun               = 0
  }

  os_profile {
    computer_name  = "${var.hostname}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = "${azurerm_storage_account.stor.primary_blob_endpoint}"
  }   
}
