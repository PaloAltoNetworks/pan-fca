output "gcp_fw_id_untrust" {
  value = "${google_compute_firewall.untrust.*.id}"
}

output "gcp_fw_name_untrust" {
  value = "${google_compute_firewall.untrust.*.name}"
}

output "gcp_fw_id_trust" {
  value = "${google_compute_firewall.trust.*.id}"
}

output "gcp_fw_name_trust" {
  value = "${google_compute_firewall.trust.*.name}"
}

output "gcp_fw_id_mgmt" {
  value = "${google_compute_firewall.management.*.id}"
}

output "gcp_fw_name_mgmt" {
  value = "${google_compute_firewall.management.*.name}"
}