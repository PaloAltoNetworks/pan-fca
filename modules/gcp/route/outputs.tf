output "next_hop_instance_route_id" {
  value = "${google_compute_route.trust-nextinstance.id}"
}

output "next_hop_instance_route_self_link" {
  value = "${google_compute_route.trust-nextinstance.self_link}"
}

output "next_hop_instance_route_project" {
  value = "${google_compute_route.trust-nextinstance.project}"
}

output "next_hop_ip_route_id" {
  value = "${google_compute_route.trust-nextip.id}"
}

output "next_hop_ip_route_self_link" {
  value = "${google_compute_route.trust-nextip.self_link}"
}

output "next_hop_ip_route_project" {
  value = "${google_compute_route.trust-nextip.project}"
}