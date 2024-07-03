#!/bin/bash

RESOURCE_GROUP="ctf-unisinos-rg"
LOCATION="eastus"
BICEP_FILE="./bicep/init.bicep"
ADMIN_USERNAME="unisinos"
ADMIN_PASSWORD=""

sudo apt-get update
sudo apt-get install -y curl apt-transport-https lsb-release software-properties-common
sudo apt install azure-cli

az bicep install

sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

echo "Por favor, faça login na sua conta Azure"
az login

az group create --name $RESOURCE_GROUP --location $LOCATION

az deployment group create --resource-group $RESOURCE_GROUP --template-file $BICEP_FILE --parameters ./bicep/init.params.json

VM_IP=$(az network public-ip show --resource-group $RESOURCE_GROUP --name ${INFRA_PREFIX}-pip --query "ipAddress" --output tsv)

echo -e "[ctfd_server]\n$VM_IP ansible_user=$ADMIN_USERNAME ansible_password=$ADMIN_PASSWORD" > hosts

ansible-playbook -i hosts ./ansible_ctfd/playbook.yaml

echo "Provisionamento concluído, arquivo de hosts do Ansible atualizado e playbook executado."

