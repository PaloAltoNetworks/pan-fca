resource "panos_panorama_service_group" "pano_service_object_group" {
  count        = "${var.device_group != "" ? 1 : 0}"
  device_group = "${var.device_group}"
  name         = "${var.name}"
  services = ["${var.services}"]

  //  tags             = ["${var.tags}"]
}

resource "panos_service_group" "fw_service_object_group" {
  count    = "${var.device_group == "" ? 1 : 0}"
  name     = "${var.name}"
  services = ["${var.services}"]

  //  tags             = ["${var.tags}"]
}
