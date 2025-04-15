param(
  [string]$resourceGroup,
  [string]$aksName
)

az login --identity
az aks stop --resource-group $resourceGroup --name $aksName
