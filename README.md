# nia-example
extremely simple example of network integrated app


## Prerequisites 

Login

```
az login --tenant <Tenant ID>

az account set --subscription <Subscription ID>
```

Create a VNET 

```
cd infra

# your unique code
projectName='mmcr'

az deployment sub create --template-file prerequisites.bicep --parameters project=$projectName --location westeurope

```

## Deploy network intergrated app

Deploy the application in the given subnet

```
cd infra

# your unique code
projectName='mmcr'

# any subnet ID (note : the subnet should be delegated to Microsoft.App/environments)
subnetResourceId='/subscriptions/<SID>/resourceGroups/<RG>/providers/Microsoft.Network/virtualNetworks/<VNET>/subnets/<SNET>'

az deployment sub create --template-file app.bicep --parameters project=$projectName subnetResourceId=$subnetResourceId --location westeurope 

```

## Result

