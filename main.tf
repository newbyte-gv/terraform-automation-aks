provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

data "azurerm_client_config" "current" {}

resource "azurerm_automation_account" "aks" {
  name                = var.automation_account_name
  location            = var.location
  resource_group_name = var.resource_group
  sku_name            = "Basic"
  identity { type = "SystemAssigned" }
}

resource "azurerm_role_assignment" "automation_contributor" {
  principal_id         = azurerm_automation_account.aks.identity[0].principal_id
  role_definition_name = "Contributor"
  scope = "/subscriptions/${var.subscription_id}/resourcegroups/${var.resource_group}/providers/Microsoft.ContainerService/managedClusters/${var.aks_name}"
}

resource "azurerm_automation_runbook" "start_aks" {
  name                    = "Start-AKS"
  location                = var.location
  resource_group_name     = var.resource_group
  automation_account_name = azurerm_automation_account.aks.name
  runbook_type            = "PowerShell"
  content                 = file("${path.module}/scripts/start-aks.ps1")
  log_verbose             = true
  log_progress            = true
}

resource "azurerm_automation_runbook" "stop_aks" {
  name                    = "Stop-AKS"
  location                = var.location
  resource_group_name     = var.resource_group
  automation_account_name = azurerm_automation_account.aks.name
  runbook_type            = "PowerShell"
  content                 = file("${path.module}/scripts/stop-aks.ps1")
  log_verbose             = true
  log_progress            = true
}

resource "azurerm_automation_schedule" "start_schedule" {
  name                    = "StartAKSWeekdays"
  resource_group_name     = var.resource_group
  automation_account_name = azurerm_automation_account.aks.name
  frequency               = "Week"
  interval                = 1
  timezone                = "America/Bogota"
  start_time              = var.start_time
  week_days               = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
}

resource "azurerm_automation_schedule" "stop_schedule" {
  name                    = "StopAKSWeekdays"
  resource_group_name     = var.resource_group
  automation_account_name = azurerm_automation_account.aks.name
  frequency               = "Week"
  interval                = 1
  timezone                = "America/Bogota"
  start_time              = var.stop_time
  week_days               = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
}

resource "azurerm_automation_job_schedule" "start_binding" {
  automation_account_name = azurerm_automation_account.aks.name
  resource_group_name     = var.resource_group
  runbook_name            = azurerm_automation_runbook.start_aks.name
  schedule_name           = azurerm_automation_schedule.start_schedule.name

  parameters = {
    resourcegroup = var.resource_group
    aksname       = var.aks_name
  }
}

resource "azurerm_automation_job_schedule" "stop_binding" {
  automation_account_name = azurerm_automation_account.aks.name
  resource_group_name     = var.resource_group
  runbook_name            = azurerm_automation_runbook.stop_aks.name
  schedule_name           = azurerm_automation_schedule.stop_schedule.name

  parameters = {
    resourcegroup = var.resource_group
    aksname       = var.aks_name
  }
}
