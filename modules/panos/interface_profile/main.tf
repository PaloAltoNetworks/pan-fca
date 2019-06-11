resource "panos_panorama_management_profile" "pano_mgmt_profile_noip" {
  count    = "${var.template != "" && var.acl == 0 ? 1 :0}"
  name     = "${var.name}"
  template = "${var.template}"
  ping     = "${var.ping}"
  ssh      = "${var.ssh}"
  telnet   = "${var.telnet}"
  https    = "${var.https}"
  snmp     = "${var.snmp}"
}

resource "panos_panorama_management_profile" "pano_mgmt_profile_ip" {
  count         = "${var.template != "" && var.acl != 0 ? 1 :0}"
  name          = "${var.name}"
  template      = "${var.template}"
  ping          = "${var.ping}"
  ssh           = "${var.ssh}"
  telnet        = "${var.telnet}"
  https         = "${var.https}"
  snmp          = "${var.snmp}"
  permitted_ips = "${var.permitted_ips}"
}

resource "panos_management_profile" "fw_mgmt_profile_noip" {
  count  = "${var.template == "" && var.acl == 0 ? 1 :0}"
  name   = "${var.name}"
  ping   = "${var.ping}"
  ssh    = "${var.ssh}"
  telnet = "${var.telnet}"
  https  = "${var.https}"
  snmp   = "${var.snmp}"
}

resource "panos_management_profile" "fw_mgmt_profile_ip" {
  count         = "${var.template == "" && var.acl != 0 ? 1 :0}"
  name          = "${var.name}"
  ping          = "${var.ping}"
  ssh           = "${var.ssh}"
  telnet        = "${var.telnet}"
  https         = "${var.https}"
  snmp          = "${var.snmp}"
  permitted_ips = "${var.permitted_ips}"
}
