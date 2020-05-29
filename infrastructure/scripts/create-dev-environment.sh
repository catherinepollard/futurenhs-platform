#!/bin/bash

set -eu

NAME="${1:?"Please enter your name as first argument"}"

RESOURCE_GROUP_NAME=tfstate$NAME
STORAGE_ACCOUNT_NAME=fnhstfstatedev$NAME
CONTAINER_NAME=tfstate

# Use non-production subscription
az account set --subscription 4a4be66c-9000-4906-8253-6a73f09f418d
# Create resource group
# TODO: do we want to limit this to england/wales, or is europe okay?
az group create --name $RESOURCE_GROUP_NAME --location westeurope

# Create storage account
az storage account create --kind StorageV2 --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCESS_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key "$ACCESS_KEY"

echo "
# Create a terraform.tfvars file (in infrastructure/environments/dev/) with the following content:

resource_group_name=\"$RESOURCE_GROUP_NAME\"
storage_account_name=\"$STORAGE_ACCOUNT_NAME\"
USERNAME=\"$NAME\"

# and then run `terraform init -backend-config=terraform.tfvars` in the same folder.
"
