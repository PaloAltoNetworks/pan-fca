resource "panos_panorama_device_group" "dg" {
  name        = "${var.name}"
  description = "${var.description}"
}
