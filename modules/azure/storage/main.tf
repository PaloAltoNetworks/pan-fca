resource "azurerm_storage_account" "pan_bootstrap_sa" {
  name                     = "${var.storage_account_name}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "${var.account_tier}"
  account_replication_type = "${var.account_replication_type}"
}

resource "azurerm_storage_share" "pan_bootstrap" {
  count = "${length(var.file_share)}"
  name                 = "${var.file_share[count.index]}"
  resource_group_name  = "${var.resource_group_name}"
  storage_account_name = "${var.storage_account_name}"
  quota                = 50
  depends_on = ["azurerm_storage_account.pan_bootstrap_sa"]
}

resource "null_resource" "bootstrap_dir" {
  count = "${length(var.file_share)}"
  depends_on = ["azurerm_storage_share.pan_bootstrap"]
  provisioner "local-exec" {
    command = <<EOT
        az storage directory create --name ${var.storage_directory[0]} --share-name ${var.file_share[count.index]} --account-name ${azurerm_storage_account.pan_bootstrap_sa.name} --account-key ${azurerm_storage_account.pan_bootstrap_sa.primary_access_key};
        az storage directory create --name ${var.storage_directory[1]} --share-name ${var.file_share[count.index]} --account-name ${azurerm_storage_account.pan_bootstrap_sa.name} --account-key ${azurerm_storage_account.pan_bootstrap_sa.primary_access_key};
        az storage directory create --name ${var.storage_directory[2]} --share-name ${var.file_share[count.index]} --account-name ${azurerm_storage_account.pan_bootstrap_sa.name} --account-key ${azurerm_storage_account.pan_bootstrap_sa.primary_access_key};
        az storage directory create --name ${var.storage_directory[3]} --share-name ${var.file_share[count.index]} --account-name ${azurerm_storage_account.pan_bootstrap_sa.name} --account-key ${azurerm_storage_account.pan_bootstrap_sa.primary_access_key}
    EOT
  }
}

resource "null_resource" "file_upload" {
  count = "${length(var.file_share)}"
  depends_on = ["null_resource.bootstrap_dir"]
  provisioner "local-exec" {
    command = <<EOT
      az storage file upload --source ./bootstrap/region/${var.location}/${var.share_type[count.index]}/${var.file_names[0]} --share-name ${var.file_share[count.index]}/${var.storage_directory[0]} --account-name ${azurerm_storage_account.pan_bootstrap_sa.name} --account-key ${azurerm_storage_account.pan_bootstrap_sa.primary_access_key};
      az storage file upload --source ./bootstrap/region/${var.location}/${var.share_type[count.index]}/${var.file_names[1]} --share-name ${var.file_share[count.index]}/${var.storage_directory[0]} --account-name ${azurerm_storage_account.pan_bootstrap_sa.name} --account-key ${azurerm_storage_account.pan_bootstrap_sa.primary_access_key};
      az storage file upload --source ./bootstrap/region/${var.location}/${var.share_type[count.index]}/${var.file_names[2]} --share-name ${var.file_share[count.index]}/${var.storage_directory[3]} --account-name ${azurerm_storage_account.pan_bootstrap_sa.name} --account-key ${azurerm_storage_account.pan_bootstrap_sa.primary_access_key}
    EOT
  }
}

output "storage_account_primary_access_key" {
  value = "${azurerm_storage_account.pan_bootstrap_sa.primary_access_key}"
}
