resource "panos_panorama_security_policy_group" "policy_pano_no_target" {
  count        = "${var.device_group != "" ? 1 : 0}"
  device_group = "${var.device_group}"
  rulebase     = "${var.rulebase_type}"

  rule {
    name                  = "${var.rule_name}"
    source_zones          = ["${var.source_zones}"]
    source_addresses      = ["${var.source_addresses}"]
    source_users          = ["${var.source_users}"]
    hip_profiles          = ["${var.hip_profiles}"]
    destination_zones     = ["${var.destination_zones}"]
    destination_addresses = ["${var.destination_addresses}"]
    applications          = ["${var.applications}"]
    services              = ["${var.services}"]
    categories            = ["${var.categories}"]
    action                = "${var.action}"
  }
}

resource "panos_security_policy_group" "policy_no_target" {
  count        = "${var.device_group == "" ? 1 : 0}"

  rule {
    name                  = "${var.rule_name}"
    source_zones          = ["${var.source_zones}"]
    source_addresses      = ["${var.source_addresses}"]
    source_users          = ["${var.source_users}"]
    hip_profiles          = ["${var.hip_profiles}"]
    destination_zones     = ["${var.destination_zones}"]
    destination_addresses = ["${var.destination_addresses}"]
    applications          = ["${var.applications}"]
    services              = ["${var.services}"]
    categories            = ["${var.categories}"]
    action                = "${var.action}"
  }
}


//resource "panos_panorama_security_policy_group" "policy_pano_target" {
//  count        = "${var.rule_type == "panorama-target" ? 1 : 0}"
//  device_group = "${var.device_group}"
//  rulebase     = "${var.rulebase_type}"
//
//  rule {
//    name                  = "${var.rule_name}"
//    source_zones          = ["${var.source_zones}"]
//    source_addresses      = ["${var.source_addresses}"]
//    source_users          = ["${var.source_users}"]
//    hip_profiles          = ["${var.hip_profiles}"]
//    destination_zones     = ["${var.destination_zones}"]
//    destination_addresses = ["${var.destination_addresses}"]
//    applications          = ["${var.applications}"]
//    services              = ["${var.services}"]
//    categories            = ["${var.categories}"]
//    action                = "${var.action}"
//  }
//}