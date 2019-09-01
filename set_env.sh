#!/bin/bash
echo "az login"
az login

echo "Enabled subscription list:"
az account list --output json | jq -r '.[].name'

echo "Enter subscription name:"
read SUBSCRIPTION

echo "Set target subscription"
az account set --subscription $SUBSCRIPTION

SUB_ID=$(az account show --output json | jq -r '.id')
JSON=$(az ad sp create-for-rbac -n "Ansible" --role contributor --scopes /subscriptions/$SUB_ID)

echo "Set a credential as environment variables to access to the subscription"
export AZURE_CLIENT_ID=$(echo $JSON | jq -r '.appId')
export AZURE_SECRET=$(echo $JSON | jq -r '.password')
export AZURE_SUBSCRIPTION_ID=$SUB_ID
export AZURE_TENANT=$(echo $JSON | jq -r '.tenant')
