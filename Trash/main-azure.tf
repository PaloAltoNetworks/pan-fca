module "VPCTransit" {
  source             = "..\/modules\/aws\/vpc"
  vpc_cidr           = "10.227.127.0/24"
  untrust_subnets    = ["10.227.127.0/27", "10.227.127.96/27"]
  trust_subnets      = ["10.227.127.64/27", "10.227.127.32/27"]
  region             = "us-east-1"
  availability_zones = ["a", "b"]
  vpc_name           = "VPCTransit"
  stack_name         = "VPCTransit"
  customer_asns      = ["65001"]
}

module "VPCTransit-firewall" {
  source                          = "..\/modules\/aws\/firewall"
  fw_instance_count               = "${length(module.VPCTransit.availability_zones)}"
  availability_zones              = ["${module.VPCTransit.availability_zones }"]
  untrust_subnets                 = ["${module.VPCTransit.untrust_subnets}"]
  untrust_security_group          = "${module.VPCTransit.untrust_security_group}"
  trust_subnets                   = ["${module.VPCTransit.trust_subnets}"]
  trust_security_group            = "${module.VPCTransit.trust_security_group}"
  mgmt_security_group             = "${module.VPCTransit.mgmt_security_group}"
  untrust_elastic_ips             = ["${module.VPCTransit.untrust_elastic_ips}"]
  management_elastic_ips          = ["${module.VPCTransit.management_elastic_ips}"]
  management_elastic_ip_addresses = ["${module.VPCTransit.management_elastic_ip_addresses}"]
  fw_key_name                     = "${var.fw_key_name}"
  fw_key                          = "${var.fw_key}"
  region                          = "us-east-1"
  stack_name                      = "VPCTransit"
}

output "firewalls_created" {
  value = "${module.VPCTransit-firewall.firewalls_created}"
}
