
# Deploy Transit #1 Bootstraps
# 
#
# Create a new Palo Alto Networks VM-series Firewall with
# bootstrapping from a S3 bucket

# Define Region
provider "aws" {
  region = "${var.region}"
}

#### Create Network Interfaces ####

resource "aws_network_interface" "FWManagementNetworkInterface" {
  count      = "${var.fw_instance_count}"
  subnet_id    = "${element(var.untrust_subnets, count.index)}"
  security_groups = ["${var.mgmt_security_group}"]
  source_dest_check = false
  #private_ips_count = 1
  #private_ips = ["10.0.0.99"]

  tags {
    "Name" = "${join("", list(var.stack_name, "FW-AZ-${count.index+1}-Mgmt"))}"
  }
}

resource "aws_network_interface" "FWPublicNetworkInterface" {
  count      = "${var.fw_instance_count}"
  subnet_id       = "${element(var.untrust_subnets, count.index)}"
  #subnet_id       = "${aws_subnet.untrust_subnet.id}"
  security_groups = ["${var.untrust_security_group}"]
  source_dest_check = false
  #private_ips_count = 1
  #private_ips = ["10.0.0.100"]

  tags {
    "Name" = "${join("", list(var.stack_name, "FW-AZ-${count.index+1}-Eth1-1"))}"
  }

}

resource "aws_network_interface" "FWPrivateNetworkInterface" {
  count      = "${var.fw_instance_count}"
  subnet_id       = "${element(var.trust_subnets, count.index)}"
  security_groups = ["${var.trust_security_group}"]
  source_dest_check = false
  #private_ips_count = 1
  #private_ips = ["10.0.1.11"]

  tags {
    "Name" = "${join("", list(var.stack_name, "FW-AZ-${count.index+1}-Eth1-2"))}"
  }
}


#### Create the Elastic IP Association ####

resource "aws_eip_association" "FWEIPManagementAssociation" {
  count = "${var.fw_instance_count}"
  network_interface_id   = "${element(aws_network_interface.FWManagementNetworkInterface.*.id, count.index)}"
  allocation_id = "${element(var.management_elastic_ips, count.index)}"
}

resource "aws_eip_association" "FWUnTrustAssociation" {
  count = "${var.fw_instance_count}"
  network_interface_id   = "${element(aws_network_interface.FWPublicNetworkInterface.*.id, count.index)}"
  allocation_id = "${element(var.untrust_elastic_ips, count.index)}"
}

// Create Key Pair for FW Access
resource "aws_key_pair" "generated_key" {
  key_name = "${var.fw_key_name}"
  public_key = "${var.fw_key}"
}

resource "aws_instance" "FWInstance" {
  count = "${var.fw_instance_count}"
  disable_api_termination = false
  #iam_instance_profile = "${aws_iam_instance_profile.FirewallBootstrapInstanceProfileServices.name}"
  instance_initiated_shutdown_behavior = "stop"
  availability_zone = "${element(var.availability_zones, count.index)}"
  ebs_optimized = true
  ami = "${var.BYOLPANFWRegionMap809[var.region]}"
  instance_type = "m4.xlarge"

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "gp2"
    delete_on_termination = true
    volume_size = 60
}
  key_name = "${aws_key_pair.generated_key.key_name}"
  monitoring = false

  network_interface {
    device_index = "0"
    network_interface_id = "${element(aws_network_interface.FWManagementNetworkInterface.*.id, count.index)}"
  }

  network_interface {
    device_index = "1"
    network_interface_id = "${element(aws_network_interface.FWPublicNetworkInterface.*.id, count.index)}"
  }

  network_interface {
    device_index = "2"
    network_interface_id = "${element(aws_network_interface.FWPrivateNetworkInterface.*.id, count.index)}"
  }
}

