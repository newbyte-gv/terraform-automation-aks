param(
  [string]$resourceGroup,
  [string]$aksName
)

az login --identity
az aks start --resource-group $resourceGroup --name $aksName
