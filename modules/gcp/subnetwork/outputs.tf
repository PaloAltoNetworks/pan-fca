output "subnetwork_self_links" {
  value = ["${google_compute_subnetwork.subnetwork.*.self_link}"]
}

output "subnetwork_id" {
  value = ["${google_compute_subnetwork.subnetwork.*.id}"]
}

output "subnetwork_gateway" {
  value = ["${google_compute_subnetwork.subnetwork.*.gateway_address}"]
}

output "subnetwork_project" {
  value = "${google_compute_subnetwork.subnetwork.project}"
}
