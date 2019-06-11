output "azurerm_sa_name" {
  value = "${azurerm_storage_account.pan_bootstrap_sa.*.name}"
}

output "azurerm_sa_primary_key" {
  value = "${azurerm_storage_account.pan_bootstrap_sa.*.primary_access_key}"
}

output "azurerm_sa_id" {
  value = "${azurerm_storage_account.pan_bootstrap_sa.*.id}"
}