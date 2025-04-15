# Terraform Automation AKS Module

Este módulo permite programar el encendido y apagado automático de un clúster AKS usando Azure Automation.

## Estructura

- Crea una cuenta de Automation
- Crea runbooks (`Start-AKS` y `Stop-AKS`)
- Programa horarios lunes a viernes (06:30 encendido, 19:00 apagado)
- Asigna permisos y vincula todo

## Uso

```hcl
module "automation_aks" {
  source                  = "./modules/automation_aks"
  subscription_id         = "xxxx-xxxx"
  resource_group          = "mi-grupo"
  location                = "East US 2"
  aks_name                = "aks-dev"
  automation_account_name = "auto-control-dev"
  start_time              = "2025-04-14T06:30:00-05:00"
  stop_time               = "2025-04-14T19:00:00-05:00"
}
```

## Scripts

Los scripts están en `scripts/` y usan la identidad administrada para iniciar sesión y ejecutar `az aks start/stop`.

---

Desarrollado por [@newbyte-gv](https://github.com/newbyte-gv)
