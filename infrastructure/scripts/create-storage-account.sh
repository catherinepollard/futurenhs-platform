#!/bin/bash

set -eu

NAME="${1:?"Please enter your name as first argument"}"

RESOURCE_GROUP_NAME=tfstate$NAME
STORAGE_ACCOUNT_NAME=tfstate$NAME
CONTAINER_NAME=tfstate

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
# Create a terraform.tfvars file with the following content
resource_group_name="$RESOURCE_GROUP_NAME"
storage_account_name="$STORAGE_ACCOUNT_NAME"
USERNAME="$NAME"
TF_VAR_STORAGE_ACCOUNT_NAME="$STORAGE_ACCOUNT_NAME"
TF_VAR_CONTAINER_NAME="$CONTAINER_NAME"
TF_VAR_ACCESS_KEY="$ACCESS_KEY"
"

