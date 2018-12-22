

data "azurerm_subnet" "datasubnet" {
  name                 = "${var.subnet_name}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.resource_group_name}"
}

resource "random_id" "vm-sa" {
  keepers = {
    vm_hostname = "${var.vm_hostname}"
  }

  byte_length = 6
}

resource "azurerm_storage_account" "vm-sa" {
  name                     = "${random_id.vm-sa.keepers.vm_hostname}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "${var.storage_account_tier}"
  account_replication_type = "${var.storage_replication_type}"
}

resource "azurerm_managed_disk" "datadisk" {
  name                 = "${var.vm_hostname}-datadisk"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  storage_account_type = "${var.storage_account_type}"
  create_option        = "Empty"
  disk_size_gb         = "1023"
}

## Build Worker Node VM

resource "azurerm_virtual_machine" "panw_worker_node" {
  name                  = "${var.vm_hostname}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.vm.id}"]
  vm_size               = "${var.vm_size}"
  delete_os_disk_on_termination = true

  storage_os_disk {
    name              = "${var.vm_hostname}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "${var.vm_hostname}-datadisk"
    managed_disk_id   = "${azurerm_managed_disk.datadisk.id}"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "1023"
    create_option     = "Attach"
    lun               = 0

  }

  storage_image_reference {
    publisher = "${var.vm_os_publisher}"
    offer     = "${var.vm_os_offer}"
    sku       = "${var.vm_os_sku}"
    version   = "${var.vm_os_version}"
  }

  os_profile {
    computer_name  = "${var.vm_hostname}"
    admin_username = "${var.admin_username}"
    custom_data    = "${data.template_file.starthub.rendered}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${file(var.public_ssh_key)}"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.vm-sa.primary_blob_endpoint}"
  }

  tags {
    environment = "Terraform Demo"
  }
}

## Network Inferface Configuration

resource "azurerm_network_interface" "vm" {
  count                     = "${var.nb_instances}"
  name                      = "nic-${var.vm_hostname}-${count.index}"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${azurerm_network_security_group.vm.id}"

  ip_configuration {
    name                          = "ipconfig${count.index}"
    subnet_id                     = "${data.azurerm_subnet.datasubnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm-pip.id}"
  }
}

## Build Public IP

resource "azurerm_public_ip" "vm-pip" {
  name                         = "${var.vm_hostname}-pip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "Terraform Demo"
  }
}

## Build Network Security Group

resource "azurerm_network_security_group" "vm" {
  name                = "${var.vm_hostname}-nsg"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

data "template_file" "starthub" {
  template = "${file(var.starthub_tmp)}"

  vars {
    AZURE_SUBSCRIPTION_ID        = "${var.azurerm_subscription_id}"
    AZURE_CLIENT_ID              = "${var.azurerm_client_id}"
    AZURE_CLIENT_SECRET          = "${var.azurerm_client_secret}"
    AZURE_TENANT_ID              = "${var.azurerm_tenant_id}"
    PANORAMA_IP                  = "${var.panorama_ip}"
    PANORAMA_API_KEY             = "${var.panorama_api_key}"
    LICENSE_DEACTIVATION_API_KEY = "${var.license_deactivation_key}"
    RG_NAME                      = "${var.resource_group_name}"
    WORKER_NAME                  = "${var.worker_name}"
    VMSS_NAME                    = "${var.scale_set_name}"
    APPINSIGHTS_NAME             = "${var.appinsights_name}"
    STORAGE_ACCT_NAME            = "${var.vmss_sa}"
    STORAGE_ACCT_RG              = "${var.vmss_sa_rg}"
    TMPL_STACK                   = "${var.temp_stack}"
  }
}

resource "null_resource" "wait_for_initialize" {
  depends_on = ["azurerm_virtual_machine.panw_worker_node"]
  provisioner "local-exec" {
    command = "sleep 120"
  }
}

resource "null_resource" remoteExecProvisionerUploadMonitor {
  depends_on = ["null_resource.wait_for_initialize"]

  connection {
    host        = "${azurerm_public_ip.vm-pip.ip_address}"
    type        = "ssh"
    user        = "${var.admin_username}"
    private_key = "${file(var.ssh_key)}"
    agent       = false
    timeout     = "30s"
  }

  provisioner "file" {
    source      = "./modules/worker_node/monitor.py"
    destination = "/worker_node/monitor.py"
  }
}

resource "null_resource" remoteExecProvisionerPostProcess {
  depends_on = ["null_resource.remoteExecProvisionerUploadMonitor"]

  connection {
    host        = "${azurerm_public_ip.vm-pip.ip_address}"
    type        = "ssh"
    user        = "${var.admin_username}"
    private_key = "${file(var.ssh_key)}"
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
          "cp /worker_node/monitor.py /worker_node/publish.py",
          "chmod 755 /worker_node/monitor.py",
          "chmod 755 /worker_node/publish.py",
          "sleep 10",
          "crontab -l > _tmp_file",
          "echo \"*/5 * * * * /worker_node/monitor.py\" >> _tmp_file",
          "crontab _tmp_file",
    ]
  }
}
