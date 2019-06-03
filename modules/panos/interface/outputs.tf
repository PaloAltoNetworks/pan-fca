output "name" {
  value = [
    "${panos_panorama_ethernet_interface.dhcp_interface.*.name}",
    "${panos_panorama_ethernet_interface.static_interface.*.name}"
  ]
}