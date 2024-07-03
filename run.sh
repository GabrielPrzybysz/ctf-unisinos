#!/bin/bash

# Atualiza os repositórios
sudo apt update

# Instala o Azure CLI
echo "Instalando Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Instala o Bicep
echo "Instalando Bicep..."
curl -Lo bicep https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64
chmod +x ./bicep
sudo mv ./bicep /usr/local/bin/bicep

# Instala o Ansible
echo "Instalando Ansible..."
sudo apt install -y ansible

echo "Instalação concluída."
