resource "panos_panorama_address_object" "pano_address_object" {
  count        = "${var.device_group != "" ? 1: 0 }"
  name         = "${var.name}"
  value        = "${var.value}"
  description  = "${var.description}"
  device_group = "${var.device_group}"

  //    tags = ["${var.tags}"]
}

resource "panos_address_object" "fw_address_object" {
  count       = "${var.device_group == "" ? 1: 0 }"
  name        = "${var.name}"
  value       = "${var.value}"
  description = "${var.description}"

  //    tags = ["${var.tags}"]
}
