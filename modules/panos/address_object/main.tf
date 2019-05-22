resource "panos_panorama_address_object" "pano_address_object" {
    name = "${var.name}"
    value = "${var.value}"
    description = "${var.description}"
//    tags = ["${var.tags}"]
}