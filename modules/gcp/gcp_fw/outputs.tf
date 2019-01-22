output "gcp_fw_id_custom" {
  value = "${google_compute_firewall.fw-custom.*.id}"
}

output "gcp_fw_name_custom" {
  value = "${google_compute_firewall.fw-custom.*.name}"
}

output "gcp_fw_id_all" {
  value = "${google_compute_firewall.fw-all.*.id}"
}

output "gcp_fw_name_all" {
  value = "${google_compute_firewall.fw-all.*.name}"
}