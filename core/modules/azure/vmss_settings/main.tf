resource "azurerm_autoscale_setting" "settings" {
  name                = "${var.vmss_settings_name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  target_resource_id  = "${var.vmss_id}"

  profile {
    name = "${var.scale_profile_name}"

    capacity {
      default = "${var.vmss_default_cap}"
      minimum = "${var.vmss_min_cap}"
      maximum = "${var.vmss_max_cap}"
    }

    rule {
      metric_trigger {
        metric_name        = "${var.scale_out_metric_name}"
        metric_resource_id = "${var.vmss_id}"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = "${var.scale_out_threshold}"
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
        metric_name        = "${var.scale_in_metric_name}"
        metric_resource_id = "${var.vmss_id}"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = "${var.scale_in_threshold}"
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
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["${var.email_notify}"]
    }
  }
}