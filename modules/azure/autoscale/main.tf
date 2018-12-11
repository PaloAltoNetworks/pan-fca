

data "azurerm_storage_account" "pan_bootstrap_data" {
  name                 = "${var.storage_account}"
  resource_group_name  = "${var.resource_group_name}"
}

resource "azurerm_virtual_machine_scale_set" "panfw_scale" {
 name                = "${var.scale_set_name}"
 location            = "${var.location}"
 resource_group_name = "${var.resource_group_name}"
 upgrade_policy_mode = "Manual"

 sku {
   name     = "${var.fw_size}"
   capacity = 2
 }

 plan {
        name      = "${var.fw_sku}"
        product   = "${var.fw_series}"
        publisher = "${var.fw_publisher}"
      }

 storage_profile_image_reference {
    publisher     = "${var.fw_publisher}"
    offer         = "${var.fw_series}"
    sku           = "${var.fw_sku}"
    version       = "${var.fw_version}"
 }

 storage_profile_os_disk {
   name              = ""
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 storage_profile_data_disk {
   lun          = 0
   caching        = "ReadWrite"
   create_option  = "Empty"
   disk_size_gb   = 10
 }

 os_profile {
   computer_name_prefix = "${var.host_prefix_name}"
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
     name                                   = "IPConfiguration"
     primary                                = true
     subnet_id                              = "${var.vnet_subnet_id_mgmt}"
	 public_ip_address_configuration {
		domain_name_label = "${var.domain_name_label}"
		idle_timeout = "16"
		name = "${var.public_dns_name}"
	 }
   }
 }

network_profile {
   name    = "trust"
   primary = false
   ip_forwarding = true

   ip_configuration {
     name                                   = "IPConfiguration"
     primary                                = false
     subnet_id                              = "${var.vnet_subnet_id_trust}"
     load_balancer_backend_address_pool_ids = ["${var.lb_backend_pool_trust}"]
   }
 }

 network_profile {
   name    = "untrust"
   primary = false
   ip_forwarding = true

   ip_configuration {
     name                                   = "IPConfiguration"
     primary                                = false
     subnet_id                              = "${var.vnet_subnet_id_untrust}"
     load_balancer_backend_address_pool_ids = ["${var.lb_backend_pool_untrust}"]
   }
 }

 tags = "${var.tags}"
}

# ********** Azure Scale Set Settings **********

# Create Azure Scale Set Settings for the Firewalls

resource "azurerm_autoscale_setting" "settings" {
  name                = "${var.scale_auto_setting_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  target_resource_id  = "${azurerm_virtual_machine_scale_set.panfw_scale.id}"

  profile {
    name = "defaultProfile"

    capacity {
      default = "${var.vmss_def_capacity}"
      minimum = "${var.vmss_min_capacity}"
      maximum = "${var.vmss_max_capacity}"
    }

    rule {
      metric_trigger {
        metric_name         = "Percentage CPU"
        metric_resource_id  = "${azurerm_virtual_machine_scale_set.panfw_scale.id}"
        time_grain          = "PT1M"
        statistic           = "Average"
        time_window         = "PT5M"
        time_aggregation    = "Average"
        operator            = "GreaterThan"
        threshold           = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name         = "Percentage CPU"
        metric_resource_id  = "${azurerm_virtual_machine_scale_set.panfw_scale.id}"
        time_grain          = "PT1M"
        statistic           = "Average"
        time_window         = "PT5M"
        time_aggregation    = "Average"
        operator            = "LessThan"
        threshold           = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  notification {
    #operation = "Scale"
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["${var.email_notify}"]
    }
  }
}