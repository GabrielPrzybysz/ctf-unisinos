@description('Location of the resource group')
param location string

@description('Infra Prefix')
param infraPrefix string

@description('Name of the subnet')
param subnetName string

@description('Size of the VM')
param vmSize string

@description('VM Username')
param adminUsername string 

@description('VM Password')
@secure()
param adminPassword string

// Create public IP
resource publicIp 'Microsoft.Network/publicIPAddresses@2023-02-01' = {
  name: '${infraPrefix}-pip'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Create NSG and rules for port 8000 and 22
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name:  '${infraPrefix}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: '${infraPrefix}-allow8000'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '8000'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: '${infraPrefix}-allow22'
        properties: {
          priority: 1001
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// Create VNet and subnet
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: '${infraPrefix}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/25']
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/25'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}
// Create network interface
resource networkInterface 'Microsoft.Network/networkInterfaces@2023-02-01' = {
  name: '${infraPrefix}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          subnet: {
            id: virtualNetwork.properties.subnets[0].id
          }
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
  }
}

// Create Ubuntu VM
resource virtualMachine 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: '${infraPrefix}-vm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
    }
    osProfile: {
      computerName: '${infraPrefix}-vm'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}
