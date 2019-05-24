resource "panos_panorama_virtual_router" "pano_vr" {
  count      = "${var.template != "" ? 1 :0}"
  name       = "${var.name}"
  template   = "${var.template}"
  vsys       = "${var.vsys}"
}


resource "panos_virtual_router" "pano_vr" {
  count      = "${var.template == "" ? 1 :0}"
  name       = "${var.name}"
  vsys       = "${var.vsys}"
}