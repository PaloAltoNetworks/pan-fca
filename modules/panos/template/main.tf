resource "panos_panorama_template" "template" {
  name        = "${var.name}"
  description = "${var.description}"
}
