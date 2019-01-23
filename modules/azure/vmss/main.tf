resource "random_string" "fqdn" {
  length  = 6
  special = false
  upper   = false
  number  = false
}

data "azurerm_storage_account" "pan_bootstrap_data" {
  name                = "${var.storage_account}"
  resource_group_name = "${var.rg_transit_name}"
}

data "azurerm_subnet" "panmgmt" {
  name                 = "${var.subnet_names[2]}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.rg_transit_name}"
}

data "azurerm_subnet" "untrust" {
  name                 = "${var.subnet_names[0]}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.rg_transit_name}"
}

data "azurerm_subnet" "trust" {
  name                 = "${var.subnet_names[1]}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.rg_transit_name}"
}


resource "azurerm_virtual_machine_scale_set" "panfw_scale" {
  name                = "${var.scale_set_name}"
  location            = "${var.location}"
  resource_group_name = "${var.rg_transit_name}"
  upgrade_policy_mode = "Manual"

  sku {
    name = "${var.fw_size}"
    #tier     = "Standard"
    capacity = 2
  }

  plan {
    name      = "${var.fw_sku}"
    product   = "${var.fw_series}"
    publisher = "${var.fw_publisher}"
  }

  storage_profile_image_reference {
    publisher = "${var.fw_publisher}"
    offer     = "${var.fw_series}"
    sku       = "${var.fw_sku}"
    version   = "${var.fw_version}"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "${var.hostname_prefix}"
    admin_username       = "${var.admin_user}"
    admin_password       = "${var.admin_password}"
    custom_data          = "storage-account=${var.storage_account},access-key=${data.azurerm_storage_account.pan_bootstrap_data.primary_access_key},file-share=${var.file_share},share-directory=${var.bootstrap_dir}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "pan-mgmt"
    primary = true

    ip_configuration {
      name      = "IPConfiguration"
      primary   = true
      subnet_id = "${data.azurerm_subnet.panmgmt.id}"

      public_ip_address_configuration {
        domain_name_label = "${var.domain_name_label}"
        idle_timeout      = "16"
        name              = "${var.public_ip_name}"
      }
    }
  }

  network_profile {
    name          = "untrust"
    primary       = false
    ip_forwarding = true

    ip_configuration {
      name                                   = "IPConfiguration"
      primary                                = false
      subnet_id                              = "${var.subnet_pool_id_untrust}"
      load_balancer_backend_address_pool_ids = ["${var.backend_pool_id_untrust}"]
    }
  }

  network_profile {
    name          = "trust"
    primary       = false
    ip_forwarding = true

    ip_configuration {
      name                                   = "IPConfiguration"
      primary                                = false
      subnet_id                              = "${var.subnet_pool_id_trust}"
      load_balancer_backend_address_pool_ids = ["${var.backend_pool_id_trust}"]
    }
  }

  tags = "${var.tags}"
}