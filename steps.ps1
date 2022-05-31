################################################################
# resource Group :
#southcentralus centralus francecentral
$Global:RGLocation = "francecentral"
$Global:RGName = "packer-rg"

#######################################################################
# Steps :

az group create --name $RGName --location $RGLocation

$keyfile = '.\keys.json'
az ad sp create-for-rbac `
    --role Contributor `
    --scopes /subscriptions/af783b88-9530-433e-9520-32a8accf75a5 `
    --query "{ client_id: appId, client_secret: password, tenant_id: tenant }" | Out-File $keyfile
$Global:credentials = Get-Content $keyfile -Raw | ConvertFrom-Json 

$subscriptionfile = '.\subscription.json'
az account show --query "{ subscription_id: id }" | Out-File $subscriptionfile
$Global:subscription_id = (Get-Content $subscriptionfile -Raw | ConvertFrom-Json).subscription_id

$demofile = '.\ubuntu.json'

$myJson = Get-Content $demofile -Raw | ConvertFrom-Json 
$myJson.builders[0].client_id = $credentials.client_id
$myJson.builders[0].client_secret = $credentials.client_secret
$myJson.builders[0].tenant_id = $credentials.tenant_id
$myJson.builders[0].subscription_id = $subscription_id
$myJson.builders[0].managed_image_resource_group_name = $RGName
$myJson | ConvertTo-Json -Depth 4 | Out-File $demofile -Encoding Ascii -Force

az ad sp create-for-rbac --name alexei-service-principal
$Global:service_principal_id = (az ad sp create-for-rbac --name alexei-service-principal | ConvertFrom-Json).appId
az role assignment create --assignee $service_principal_id --role Contributor

# packer build demo.json

