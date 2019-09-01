#!/bin/bash
echo "az login"
az login

echo "Enabled subscription list:"
az account list --output json | jq -r '.[].name'

echo "Enter subscription name to permit access to deploy server:"
read SUBSCRIPTION
az account set --subscription $SUBSCRIPTION

echo "Create a service pricipal to access to the subscription:"
az ad sp create-for-rbac -n "Ansible" --role contributor --scopes /subscriptions/$(az account show --output json | jq -r '.id')
