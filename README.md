# terraform-automation-aks

Módulo reusable de Terraform que automatiza el encendido y apagado de clústeres AKS en Azure mediante **Azure Automation**.

---

## 📦 ¿Qué hace este módulo?

- Crea una cuenta de Azure Automation
- Define dos runbooks en PowerShell:
  - `Start-AKS` para encender un clúster AKS
  - `Stop-AKS` para apagar un clúster AKS
- Crea dos programaciones automáticas:
  - Encendido de lunes a viernes a las 06:30
  - Apagado de lunes a viernes a las 19:00
- Asigna los permisos necesarios a la identidad administrada para operar el AKS

---

## 🧰 Requisitos

- Terraform `>= 1.3`
- Provider `azurerm >= 3.0`
- Una suscripción activa en Azure
- Un clúster AKS ya existente

---

## 🚀 Uso

Puedes consumir este módulo localmente o desde GitHub:

```hcl
module "automation_aks" {
  source = "./modules/automation_aks"

  subscription_id         = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  resource_group          = "GR_CargaMasiva"
  location                = "East US 2"
  aks_name                = "cmasivadev-aks"
  automation_account_name = "auto-control-cmasiva"
  start_time              = "2025-04-16T06:30:00-05:00"
  stop_time               = "2025-04-16T19:00:00-05:00"
}
```

> ⚠️ **Nota:** Las horas deben estar en formato [RFC3339](https://datatracker.ietf.org/doc/html/rfc3339) y con zona horaria explícita (ej. `-05:00` para Bogotá)

---

## 📂 Estructura del módulo

```
modules/
└── automation_aks/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── scripts/
        ├── start-aks.ps1
        └── stop-aks.ps1
```

---

## 🧪 Validación

Una vez desplegado, puedes verificar desde el portal de Azure:

- **Automation Account** → Runbooks → Schedules vinculados
- **Parameters** → Los runbooks reciben `resourcegroup` y `aksname`
- Puedes ejecutar los runbooks manualmente para validar el comportamiento

---

## 📤 Outputs

```hcl
output "automation_account_name" {
  value = azurerm_automation_account.aks.name
}

output "start_runbook_url" {
  value = "https://portal.azure.com/#resource${azurerm_automation_runbook.start_aks.id}"
}

output "stop_runbook_url" {
  value = "https://portal.azure.com/#resource${azurerm_automation_runbook.stop_aks.id}"
}
```

---

## 👤 Autor

Desarrollado por **Guillermo Vallejo**  
🔗 [github.com/newbyte-gv](https://github.com/newbyte-gv)

---

## 📝 Licencia

MIT License
