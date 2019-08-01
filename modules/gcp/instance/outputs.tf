output "self_link" {
  value = ["${google_compute_instance.instance.*.self_link}"]
}

output "name" {
  value = ["${google_compute_instance.instance.*.name}"]
}

output "web_self_link" {
  value = ["${google_compute_instance.webserver.*.self_link}"]
}

output "web_name" {
  value = ["${google_compute_instance.webserver.*.name}"]
}

output "untrust-private-ip" {
  value = ["${google_compute_instance.instance.*.network_interface.0.network_ip }"]
}

output "trust-private-ip" {
  value = "${google_compute_instance.instance.*.network_interface.2.network_ip }"
}

output "mgmt-private-ip" {
  value = "${google_compute_instance.instance.*.network_interface.1.network_ip }"
}

output "mgmt-public-ip" {
  value = ["${google_compute_instance.instance.*.network_interface.1.access_config.0.nat_ip }"]
}

output "untrust-public-ip" {
  value = ["${google_compute_instance.instance.*.network_interface.0.access_config.0.nat_ip }"]
}