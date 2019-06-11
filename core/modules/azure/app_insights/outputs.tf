output "instrumentation_key" {
  value = "${azurerm_application_insights.appinsight.instrumentation_key}"
}

output "app_id" {
  value = "${azurerm_application_insights.appinsight.app_id}"
}

output "appinsights_id" {
  value = "${azurerm_application_insights.appinsight.id}"
}