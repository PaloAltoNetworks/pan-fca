output "firewalls_created" {
    description = "List of firewalls created"
    value = "${zipmap(
      aws_instance.FWInstance.*.name, aws_eip.management_elastic_ip.*.public_ip)}
}
