resource "panos_panorama_zone" "new_zone_nouserid" {
  count    = "${var.enable_user_id == 0 ? 1 : 0}"
  name     = "${var.name}"
  template = "${var.template}"
  mode     = "${var.mode}"
  interfaces     = ["${var.interfaces}"]
}

resource "panos_panorama_zone" "new_zone_userid" {
  count    = "${var.enable_user_id == 1 ? 1 : 0}"
  name     = "${var.name}"
  template = "${var.template}"
  mode     = "layer3"

  //  interfaces     = ["${var.interfaces}"]
  enable_user_id = "${var.enable_user_id}"
//  exclude_acls   = ["${var.exclude_acls}"]
}
