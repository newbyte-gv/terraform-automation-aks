output "automation_account_name" {
  value = azurerm_automation_account.aks.name
}

output "start_runbook_url" {
  value = "https://portal.azure.com/#resource${azurerm_automation_runbook.start_aks.id}"
}

output "stop_runbook_url" {
  value = "https://portal.azure.com/#resource${azurerm_automation_runbook.stop_aks.id}"
}
