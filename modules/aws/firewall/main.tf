
#### Create Network Interfaces ####

// Create Key Pair for FW Access
resource "aws_key_pair" "generated_key" {
  key_name   = "${var.fw_key_name}"
  public_key = "${var.fw_key}"
}

#### PA VM AMI ID Lookup based on license type, region, version ####

data "aws_ami" "pa-vm" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["aws-marketplace"]
  }

  filter {
    name   = "product-code"
    values = ["${var.fw_license_type_map[var.fw_license_type]}"]
  }

  filter {
    name   = "name"
    values = ["PA-VM-AWS-${var.fw_version}*"]
  }
}

#### Create the Firewall Instances ####

resource "aws_instance" "FWInstance" {
  disable_api_termination = false

  #iam_instance_profile = "${aws_iam_instance_profile.FirewallBootstrapInstanceProfileServices.name}"
  instance_initiated_shutdown_behavior = "stop"
  ebs_optimized                        = true
  ami                                  = "${data.aws_ami.pa-vm.id}"
  instance_type                        = "m4.xlarge"
  tags                                 = "${merge(map("Name", format("%s", var.name)))}"

  root_block_device {
    delete_on_termination = true
  }

  key_name   = "${aws_key_pair.generated_key.key_name}"
  monitoring = false

}


#### Attache the ENIs ####


resource "aws_network_interface_attachment" "this" {
  count                = "${length(var.eni_attachment_ids) > 0 ? length(var.eni_attachment_ids) : 0}"   
  instance_id          = "${element(aws_instance.FWInstance.*.id, count.index)}"
  network_interface_id = "${element(var.eni_attachment_ids, count.index)}"
  device_index         = "${length(var.eni_attachment_ids) > 0 ? length(var.eni_attachment_ids) : 0}"  
}

//resource "null_resource" "wait_for_https" {
//  depends_on = ["aws_instance.FWInstance"]
//
//  provisioner "local-exec" {
//    command = "sleep ${var.mgmt_sleep}"
//  }
//}
//
//resource "null_resource" "localExecSetAdmin" {
//  depends_on = ["null_resource.wait_for_https"]
//  count      = "${var.fw_instance_count}"
//
//  provisioner "local-exec" {
//    command = "${var.go_path} -key=${var.fw_priv_key_path} -host=${element(var.management_elastic_ip_addresses, count.index)} -username=${var.username} -password=${var.password}"
//  }
//}
