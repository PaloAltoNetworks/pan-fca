output "fw_name" {
  value = "${panos_address_object.fw_address_object.*.name}"
}

output "pano_name" {
  value = "${panos_panorama_address_object.pano_address_object.*.name}"
}