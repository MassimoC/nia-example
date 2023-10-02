#!/bin/bash
projectName='mmcr'

az deployment sub create --template-file prerequisites.bicep --parameters project=$projectName --location westeurope

