resource "panos_panorama_nat_rule_group" "pano source_nat_dipp" {
  count        = "${var.device_group != "" && var.rule_type == "source_nat_dipp" ? 1 : 0}"
  device_group = "${var.device_group}"
  rulebase     = "${var.rulebase_type}"

  rule {
    name = "${var.rule_name}"

    original_packet {
      source_zones          = ["${var.source_zones}"]
      destination_zone      = "${var.destination_zone}"
      destination_interface = "${var.destination_interface}"
      source_addresses      = ["${var.source_addresses}"]
      destination_addresses = ["${var.destination_addresses}"]
      service               = "${var.service}"
    }

    translated_packet {
      source {
        dynamic_ip_and_port {
          interface_address {
            interface  = "${var.tp_interface}"
            ip_address = "${var.tp_int_address == "none" ? "" : var.tp_int_address}"
          }
        }
      }

      destination {
        static {
          address = "${var.destination_tp_static_ip_address == "none" ? "" : var.destination_tp_static_ip_address}"

          //          port    = "${var.destination_tp_static_ip_address == "none" ? "" : var.destination_tp_port}"
        }
      }
    }
  }
}

resource "panos_panorama_nat_rule_group" "pano_source_nat_static" {
  count        = "${var.device_group != "" && var.rule_type == "source_nat_static" ? 1 : 0}"
  device_group = "${var.device_group}"
  rulebase     = "${var.rulebase_type}"

  rule {
    name = "${var.rule_name}"

    original_packet {
      source_zones          = ["${var.source_zones}"]
      destination_zone      = "${var.destination_zone}"
      destination_interface = "${var.destination_interface}"
      source_addresses      = ["${var.source_addresses}"]
      destination_addresses = ["${var.destination_addresses}"]
      service               = "${var.service}"
    }

    translated_packet {
      source {
        static_ip {
          translated_address = "${var.translated_address}"
          bi_directional     = "${var.bi_directional}"
        }
      }

      destination {
        static {
          address = "${var.destination_tp_static_ip_address}"
          port    = "${var.destination_tp_port}"
        }
      }
    }
  }
}

resource "panos_nat_rule_group" "fw_source_nat_dipp" {
  count        = "${var.device_group == "" && var.rule_type == "source_nat_dipp" ? 1 : 0}"
  device_group = "${var.device_group}"
  rulebase     = "${var.rulebase_type}"

  rule {
    name = "${var.rule_name}"

    original_packet {
      source_zones          = ["${var.source_zones}"]
      destination_zone      = "${var.destination_zone}"
      destination_interface = "${var.destination_interface}"
      source_addresses      = ["${var.source_addresses}"]
      destination_addresses = ["${var.destination_addresses}"]
      service               = "${var.service}"
    }

    translated_packet {
      source {
        dynamic_ip_and_port {
          interface_address {
            interface  = "${var.tp_interface}"
            ip_address = "${var.tp_int_address == "none" ? "" : var.tp_int_address}"
          }
        }
      }

      destination {
        static {
          address = "${var.destination_tp_static_ip_address == "none" ? "" : var.destination_tp_static_ip_address}"

          //          port    = "${var.destination_tp_static_ip_address == "none" ? "" : var.destination_tp_port}"
        }
      }
    }
  }
}

resource "panos_nat_rule_group" "fw_source_nat_static" {
  count        = "${var.device_group == "" && var.rule_type == "source_nat_static" ? 1 : 0}"

  rule {
    name = "${var.rule_name}"

    original_packet {
      source_zones          = ["${var.source_zones}"]
      destination_zone      = "${var.destination_zone}"
      destination_interface = "${var.destination_interface}"
      source_addresses      = ["${var.source_addresses}"]
      destination_addresses = ["${var.destination_addresses}"]
      service               = "${var.service}"
    }

    translated_packet {
      source {
        static_ip {
          translated_address = "${var.translated_address}"
          bi_directional     = "${var.bi_directional}"
        }
      }

      destination {
        static {
          address = "${var.destination_tp_static_ip_address}"
          port    = "${var.destination_tp_port}"
        }
      }
    }
  }
}