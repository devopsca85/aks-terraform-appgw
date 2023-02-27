# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group for the AKS cluster
resource "azurerm_resource_group" "aks_cluster_rg" {
  name     = "20230224-Inderjit-S"
  location = "eastus"
}

# Create the virtual networks
resource "azurerm_virtual_network" "vnet_a" {
  name                = "vnet-a"
  resource_group_name = azurerm_resource_group.aks_cluster_rg.name
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
}


resource "azurerm_subnet" "subnet_a_1" {
  name                 = "subnet-a-1"
  resource_group_name  = azurerm_resource_group.aks_cluster_rg.name
  virtual_network_name = azurerm_virtual_network.vnet_a.name
  address_prefixes      = ["10.0.0.0/24", "10.1.0.0/24"]
}

resource "azurerm_virtual_network" "vnet_b" {
  name                = "vnet-b"
  resource_group_name = azurerm_resource_group.aks_cluster_rg.name
  address_space       = ["10.1.0.0/16"]
  location            = "eastus"
}

resource "azurerm_subnet" "subnet_b_1" {
  name                 = "subnet-b-1"
  resource_group_name  = azurerm_resource_group.aks_cluster_rg.name
  virtual_network_name = azurerm_virtual_network.vnet_b.name
  address_prefixes      = ["10.1.0.0/24", "10.1.1.0/24"]
}

# Create the peering
resource "azurerm_virtual_network_peering" "vnet_a_b_peering" {
  name                           = "vnet-a-b-peering"
  resource_group_name            = azurerm_resource_group.aks_cluster_rg.name
  virtual_network_name           = azurerm_virtual_network.vnet_a.name
  remote_virtual_network_id      = azurerm_virtual_network.vnet_b.id
  allow_virtual_network_access   = true
  allow_forwarded_traffic        = true
  allow_gateway_transit          = true
  use_remote_gateways            = true
}
