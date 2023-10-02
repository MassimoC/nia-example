targetScope = 'subscription'

@minLength(3)
@maxLength(5)
param project string = 'mmcr'
param subnetResourceId string
param location string = deployment().location
param tags object = {}

@description('Optional. Workload profiles configured for the Managed Environment.')
param workloadProfiles array = [ 
{
    name: 'Consumption'
    workloadProfileType: 'Consumption'
  }
  {
    name: 'wp-01'
    workloadProfileType: 'D4'
    MinimumCount: 1
    MaximumCount: 1
  } 
]

// Variables
var deploymentName = deployment().name
var resourceGroupName = 'rg-${project}'
var logAnalyticsName = 'law-${project}'
var acaEnvironmentName = 'env-${project}'
var infrastructureResourceGroupName = 'ME_${resourceGroupName}'
var appName = 'app-podinfo'

// Resource Group
module modResourceGroup 'CARML/resources/resource-group/main.bicep' = {
  name: take('${deploymentName}-rg', 58)
  params: {
    name: resourceGroupName
    location: location
    tags: tags
  }
}

// Log Analytics Workspace
module modLogAnalytics 'CARML/operational-insights/workspace/main.bicep' ={
  name: take('${deploymentName}-law', 58)
  scope : resourceGroup(resourceGroupName)
  params: {
    name: logAnalyticsName
    location:location
    tags: tags
  }
  dependsOn: [
    modResourceGroup
  ]
}

// ACA environment
module modAcaEnvironment  'CARML/app/managed-environment/main.bicep' = {
  name: take('${deploymentName}-aca', 58)
  scope : resourceGroup(resourceGroupName)
  params: {
    name: acaEnvironmentName
    location: location
    tags: tags
    logAnalyticsWorkspaceResourceId: modLogAnalytics.outputs.resourceId
    enableDefaultTelemetry: false
    internal: true
    infrastructureResourceGroup : infrastructureResourceGroupName
    infrastructureSubnetId: subnetResourceId
    workloadProfiles: workloadProfiles
  }
  dependsOn: [ 
    modResourceGroup 
    modLogAnalytics
  ]
}

// podInfo on ACA
module app01 'CARML/app/container-app/main.bicep' = {
  name: take('${deploymentName}-app', 58)
  scope: resourceGroup(resourceGroupName)
  params: {
    name: appName
    environmentId: modAcaEnvironment.outputs.resourceId
    ingressAllowInsecure:true
    ingressExternal:false
    ingressTargetPort: 9898
    ingressTransport:'auto'
    containers: [
      {
        image: 'ghcr.io/stefanprodan/podinfo:latest'
        name: appName
        resources:{
          cpu: json('1')
          memory:'2Gi'
        }
      }
    ]
    scaleMinReplicas : 1
    scaleMaxReplicas: 3
    workloadProfileName: 'wp-01'
    location: location
    tags: tags
  }
  dependsOn: [
    modAcaEnvironment
  ]
}

