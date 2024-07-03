# ctf-unisinos

O que é necessário?

- Azure CLI
- Azure Bicep 
- Ansible

1. az login

2. az group create --name ctf-unisinos --location eastus

3. az deployment group create --resource-group ctf-unisinos-rg  --template-file ./bicep/init.bicep --parameters ./bicep/params/init.params.json

4. ansible-playbook -i ./ansible_ctfd/hosts ./ansible_ctfd/playbook.yaml