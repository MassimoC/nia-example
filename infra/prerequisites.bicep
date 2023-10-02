targetScope = 'subscription'

@minLength(3)
@maxLength(5)
param project string = 'mmcr'
param location string = deployment().location
param tags object = {}

// Variables
var deploymentName = deployment().name
var resourceGroupName = 'rg-${project}'
var virtualNetworkName = 'vnet-${project}'


// Resource Group
module modResourceGroup 'CARML/resources/resource-group/main.bicep' = {
  name: take('${deploymentName}-rg', 58)
  params: {
    name: resourceGroupName
    location: location
    tags: tags
  }
}

// Networking
module modNetworking 'modules/network.bicep' = {
  name: take('${deploymentName}-net', 58)
  scope : resourceGroup(resourceGroupName)
  params: {
    virtualNetworkName: virtualNetworkName
    location: location
  }
  dependsOn: [
    modResourceGroup
  ]
}

//output virtualNetworkId string = modNetworking.outputs.virtualNetworkId
