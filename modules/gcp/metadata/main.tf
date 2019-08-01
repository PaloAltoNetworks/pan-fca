resource "google_compute_project_metadata_item" "ssh-keys" {
  count = "${var.public_key != "" ? 1 :0 }"
  key   = "ssh-keys"
  value = "admin:${var.public_key}"
}

resource "google_compute_project_metadata_item" "interface-swap" {
  count = "${var.int_swap == 1 ? 1 : 0 }"
  key   = "mgmt-interface-swap"
  value = "enable"
}
