resource "panos_panorama_address_group" "pano_address_group_static" {
  count        = "${var.device_group != "" && var.type == "static" ? 1: 0 }"
  name         = "${var.name}"
  description  = "${var.description}"
  device_group = "${var.device_group}"
  static_addresses = ["${var.static_addresses}"]
  //    tags = ["${var.tags}"]
}

resource "panos_panorama_address_group" "pano_address_group_dynamic" {
  count        = "${var.device_group != "" && var.type != "static" ? 1: 0 }"
  name         = "${var.name}"
  description  = "${var.description}"
  device_group = "${var.device_group}"
  dynamic_match = "${var.dynamic_match}"
  //    tags = ["${var.tags}"]
}

resource "panos_address_group" "fw_address_group_static" {
  count       = "${var.device_group == "" && var.type == "static" ? 1: 0 }"
  name        = "${var.name}"
  description = "${var.description}"
  static_addresses = ["${var.static_addresses}"]

  //    tags = ["${var.tags}"]
}

resource "panos_address_group" "fw_address_group_dynamic" {
  count       = "${var.device_group == "" && var.type == "dynamic" ? 1: 0 }"
  name        = "${var.name}"
  description = "${var.description}"
  dynamic_match = "${var.dynamic_match}"

  //    tags = ["${var.tags}"]
}