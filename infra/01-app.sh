#!/bin/bash
projectName='mmcr'
subnetResourceId='/subscriptions/sid/resourceGroups/rg-mmcr-net/providers/Microsoft.Network/virtualNetworks/vnet-mmcr/subnets/firstSubnet'

az deployment sub create --template-file app.bicep --parameters project=$projectName subnetResourceId=$subnetResourceId --location westeurope 
