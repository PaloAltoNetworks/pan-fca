output "gcp_net_id" {
  value = "${google_compute_network.network.id}"
}

output "gcp_net_uri" {
  value =  "${google_compute_network.network.self_link}"
}

output "gcp_net_project" {
  value = "${google_compute_network.network.project}"
}

output "gcp_gateway_ipv4" {
  value = "${google_compute_network.network.gateway_ipv4}"
}

output "gcp_net_selflink" {
  value = "${google_compute_network.network.self_link}"
}
