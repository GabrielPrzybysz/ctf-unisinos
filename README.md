# ctf-unisinos

chmod +x ./run.sh

./run.sh

az login

az group create --name ctf-unisinos --location eastus

az deployment group create --resource-group ctf-unisinos-rg  --template-file init.bicep --parameters init.params.json

ansible-playbook -i ./ansible_ctfd/hosts ./ansible_ctfd/playbook.yaml