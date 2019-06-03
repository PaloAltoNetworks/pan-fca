output "pano_name"{
  value = "${panos_panorama_service_object.pano_service_object.*.name}"
}

output "pano_destination_port" {
  value = "${panos_panorama_service_object.pano_service_object.*.destination_port}"
}

output "fw_name" {
  description = ""
  value = "${panos_service_object.fw_service_object.*.name}"
}

output "fw_destination_port" {
  description = ""
  value = "${panos_service_object.fw_service_object.*.destination_port}"
}