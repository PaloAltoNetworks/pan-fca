provider "panos" {
  hostname = "IP ADDRESS"
  api_key  = "APIKEY"
}

module "sec_rule1" {
  source                = "../security_rule"
  rule_name             = "azure_test_rule1"
  rule_type             = "panorama"
  device_group          = "Azure"
  source_zones          = ["trust1", "trust2", "trust3"]
  source_addresses      = ["1.1.1.1/32"]
  destination_zones     = ["trust1", "trust2", "trust3"]
  destination_addresses = ["2.2.2.2/32"]
  applications          = ["ssh"]
  action                = "allow"
}

module "nat_rule1" {
  source           = "../nat_rule"
  rule_name        = "azure_nat_rule1"
  rule_type        = "source_nat_dipp"
  device_group     = "Azure"
  source_zones     = ["trust"]
  destination_zone = "untrust"
  tp_interface     = "ethernet1/1"
}

module "nat_rule2" {
  source                           = "../nat_rule"
  rule_name                        = "azure_nat_rule2"
  rule_type                        = "source_nat_dipp"
  device_group                     = "Azure"
  source_zones                     = ["untrust"]
  destination_zone                 = "untrust"
  service                          = "${module.service_obj2.name[0]}"
  tp_interface                     = "ethernet1/1"
  destination_tp_static_ip_address = "2.2.2.2/32"
  destination_tp_port              = 443
}

module "service_obj1" {
  source           = "../service_object"
  device_group     = "Azure"
  name             = "tcp-22"
  description      = "SSH Port"
  protocol         = "tcp"
  destination_port = "22"

  //  tags             = ["TCP"]
}

module "service_obj2" {
  source           = "../service_object"
  device_group     = "Azure"
  name             = "tcp-8444"
  description      = "App1 Port"
  protocol         = "tcp"
  destination_port = "8444"

  //  tags             = ["TCP"]
}

module "address_obj1" {
  source = "../address_object"
  name = "AntonSubnet"
  description = ""
  value = "8.9.9.9/32"
}

module "template1" {
  source = "../template"
  name = "azure_template"
  description = "My azure template"
}

module "trust-vr" {
  source = "../virtual_router"
  name = "trust-vr"
  interfaces = [""]
  template = "${module.template1.name}"
}

module "untrust-vr" {
  source = "../virtual_router"
  name = "untrust-vr"
  interfaces = [""]
  template = "${module.template1.name}"
}


module "interface1" {
  source = "../interface"
  name = "ethernet1/1"
  type = "dhcp"
  create_dhcp_default_route = true
  dhcp_default_route_metric = false
  mode = "layer3"
  template = "${module.template1.name}"
  vr_name = "${module.untrust-vr.name}"
}

module "interface2" {
  source = "../interface"
  name = "ethernet1/2"
  type = "dhcp"
  create_dhcp_default_route = false
  dhcp_default_route_metric = false
  mode = "layer3"
  template = "${module.template1.name}"
  vr_name = "${module.trust-vr.name}"
}

module "interface3" {
  source = "../interface"
  name = "ethernet1/3"
  type = "static"
  static_ips = ["192.168.150.1/24"]
  mode = "layer3"
  template = "${module.template1.name}"
  vr_name = "${module.trust-vr.name}"
}

module "dg1" {
  source = "../device_group"
  name = "AzureNew"
}

module "trust-zone" {
  source = "../zones"
  name = "trust"
  enable_user_id = false
  interfaces = ["${module.interface3.name}"]
  template = "${module.template1.name}"
}

module "untrust-zone" {
  source = "../zones"
  name = "untrust"
  enable_user_id = false
  interfaces = ["${module.interface1.name}","${module.interface2.name}"]
  template = "${module.template1.name}"
}

module "interface-mgmt1" {
  source = "../interface_profile"
  name = "allow ping"
  ping = true
  https = true
  snmp = true
//  acl = true
//  permitted_ips = ["23.23.23.23/32"]
  template = "${module.template1.name}"
}

//module "sec_rule2" {
//  source = "../security_rule"
//  rule_name = "aws_test_rule2"
//  rule_type = "panorama"
//  device_group = "AWS"
//  source_zones = ["trust1","trust2","trust3"]
//  source_addresses = ["3.3.3.3/32"]
//  destination_zones = ["trust1","trust2","trust3"]
//  destination_addresses = ["4.4.4.4/32"]
//  applications = ["ssl"]
//  action = "allow"
//}
//
//module "sec_rule3" {
//  source = "../security_rule"
//  rule_name = "aws_test_rule3"
//  rule_type = "panorama"
//  device_group = "AWS"
//  source_zones = ["trust1","trust2","trust3"]
//  source_addresses = ["5.5.3.3/32"]
//  destination_zones = ["trust1","trust2","trust3"]
//  destination_addresses = ["6.6.4.4/32"]
//  applications = ["web-browsing"]
//  action = "deny"
//}

