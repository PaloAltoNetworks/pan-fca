output "firewalls_created" {
    description = "List of firewalls created"
    value = "${zipmap(
      aws_instance.FWInstance.*.id, 
      var.management_elastic_ip_addresses)}"
}
