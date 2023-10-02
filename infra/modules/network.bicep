// Parameters
@description('Specifies the name of the virtual network.')
param virtualNetworkName string

@description('Specifies the address prefixes of the virtual network.')
param virtualNetworkAddressPrefixes string = '10.0.0.0/8'

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object = {}


param firstSubnetName string = 'FirstSubnet'
param firstSubnetAddressPrefix string = '10.0.0.0/27'

param secondSubnetName string = 'SecondSubnet'
param secondSubnetAddressPrefix string = '10.1.0.0/27'

param thirdSubnetName string = 'ThirdSubnet'
param thirdSubnetAddressPrefix string = '10.2.0.0/27'

param fourthSubnetName string = 'FourthSubnet'
param fourthSubnetAddressPrefix string = '10.3.0.0/27'

param peSubnetName string = 'PrivateEndpointSubnet'
param peSubnetAddressPrefix string = '10.3.1.0/24'


var firstSubnet = {
  name: firstSubnetName
  properties: {
    addressPrefix: firstSubnetAddressPrefix
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    delegations: [
      {
        name: 'aka-delegation'
        properties: {
          serviceName: 'Microsoft.App/environments'
        }
      }
    ]
  }
}
var secondSubnet = {
  name: secondSubnetName
  properties: {
    addressPrefix: secondSubnetAddressPrefix
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    delegations: [
      {
        name: 'aka-delegation'
        properties: {
          serviceName: 'Microsoft.App/environments'
        }
      }
    ]
  }
}
var thirdSubnet = {
  name: thirdSubnetName
  properties: {
    addressPrefix: thirdSubnetAddressPrefix
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    delegations: [
      {
        name: 'aka-delegation'
        properties: {
          serviceName: 'Microsoft.App/environments'
        }
      }
    ]
  }
}
var fourthSubnet = {
  name: fourthSubnetName
  properties: {
    addressPrefix: fourthSubnetAddressPrefix
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    delegations: [
      {
        name: 'aka-delegation'
        properties: {
          serviceName: 'Microsoft.App/environments'
        }
      }
    ]
  }
}
var peSubnet = {
  name: peSubnetName
  properties: {
    addressPrefix: peSubnetAddressPrefix
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
  }
}

var subnets = union(
  array(firstSubnet),
  array(secondSubnet),
  array(thirdSubnet),
  array(fourthSubnet),
  array(peSubnet)
)

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: virtualNetworkName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefixes
      ]
    }
    subnets: subnets
  }
}

// Outputs
output virtualNetworkId string = vnet.id
output virtualNetworkName string = vnet.name
output firstSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, firstSubnetName)
output secondSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, secondSubnetName)
output thirdSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, thirdSubnetName)
output fourthSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, fourthSubnetName)
output firstSubnetName string = firstSubnetName
output secondSubnetName string = secondSubnetName
output thirdSubnetName string = thirdSubnetName
output fourthSubnetName string = fourthSubnetName

