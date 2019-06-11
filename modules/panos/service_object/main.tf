resource "panos_panorama_service_object" "pano_service_object" {
  count = "${var.device_group != "" ? 1 : 0}"
  device_group     = "${var.device_group}"
  name             = "${var.name}"
  protocol         = "${var.protocol}"
  description      = "${var.description}"
  source_port      = "${var.source_port}"
  destination_port = "${var.destination_port}"
//  tags             = ["${var.tags}"]
}

resource "panos_service_object" "fw_service_object" {
  count = "${var.device_group == "" ? 1 : 0}"
  name             = "${var.name}"
  protocol         = "${var.protocol}"
  description      = "${var.description}"
  source_port      = "${var.source_port}"
  destination_port = "${var.destination_port}"
//  tags             = ["${var.tags}"]
}
