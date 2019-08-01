output "pano_name"{
  value = "${panos_panorama_service_group.pano_service_object_group.*.name}"
}

output "fw_name" {
  description = ""
  value = "${panos_service_group.fw_service_object_group.*.name}"
}