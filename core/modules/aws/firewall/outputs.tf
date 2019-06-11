output "firewalls_created" {
    description = "List of firewalls created"
    value = "${zipmap(
      aws_instance.FWInstance.*.id, 
      var.management_elastic_ip_addresses)}"
}

output "firewalls_ids" {
    description = "List of firewalls IDs"
    value = "${aws_instance.FWInstance.*.id}"
}