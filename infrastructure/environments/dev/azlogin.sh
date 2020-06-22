#!/bin/bash

NAME="${1:?"Please enter your name as first argument"}"

az aks get-credentials --resource-group platform-dev-$NAME --name dev-$NAME
az aks update -n dev-$NAME -g platform-dev-$NAME --attach-acr "/subscriptions/75173371-c161-447a-9731-f042213a19da/resourceGroups/platform-production/providers/Microsoft.ContainerRegistry/registries/fnhsproduction"
