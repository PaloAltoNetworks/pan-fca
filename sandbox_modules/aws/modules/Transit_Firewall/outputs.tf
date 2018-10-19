
//transit firewall
/*output "FWEIPManagementAssociation" {
    description = "Firewall Management EIP association"
    value = "${element(concat(aws_eip.management_elastic_ip.*.id, list("")), 0)}"
}
*/