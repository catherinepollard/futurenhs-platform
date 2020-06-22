#!/bin/bash

NAME="${1:?"Please enter your name as first argument"}"

az login

#echo "Setup Dev Env"
. ../../scripts/create-dev-environment.sh $NAME

cd ../../scripts && ./create-dev-environment.sh $NAME && cd ../environments/dev

echo 'resource_group_name="tfstate'$NAME'"
storage_account_name="fnhstfstatedev'$NAME'"
USERNAME="'$NAME'"
' > terraform.tfvars

terraform init -backend-config=terraform.tfvars

terraform apply
az aks get-credentials --resource-group platform-dev-$NAME --name dev-$NAME
az aks update -n dev-$NAME -g platform-dev-$NAME --attach-acr "/subscriptions/75173371-c161-447a-9731-f042213a19da/resourceGroups/platform-production/providers/Microsoft.ContainerRegistry/registries/fnhsproduction"


# Answer yes to the terraform continue question
#printf '%s\n' yes




