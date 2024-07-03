# ctf-unisinos

What do you need?

- Azure CLI
- Azure Bicep 
- Ansible
- sshpass 

1. ```az login ```

2. update ./bicep/params/init.params.json with the password that you want

2.  ```az group create --name ctf-unisinos --location eastus ```

3.  ```az deployment group create --resource-group ctf-unisinos  --template-file ./bicep/init.bicep --parameters ./bicep/params/init.params.json ```

4.  ```az network public-ip show --resource-group ctf-unisinos --name ctf-unisinos-pip --query "ipAddress" --output tsv ```

5. add the ip to ./ansible_ctfd/hosts file

7.  ```export ANSIBLE_HOST_KEY_CHECKING=False ```

8.  ```ansible-playbook -i ./ansible_ctfd/hosts ./ansible_ctfd/playbook.yml --ask-pass ```

9. http://azure-ip:8000
