resource "panos_licensing" "auth" {
  delicense  = "${var.delicense}"
  mode       = "${var.mode}"
  auth_codes = "${var.auth_codes}"
}
