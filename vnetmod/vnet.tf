resource "azurerm_resource_group" "tfrg" {
  name     = var.azure_rg
  location = var.azure_location
}

resource "azurerm_virtual_network" "terraformvnet" {
  name                = "tfvnet"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name
  address_space       = [var.vnet_cidr] 
}

resource "azurerm_subnet" "subnet1" {
  name                 = "sub1"
  resource_group_name  = azurerm_resource_group.tfrg.name
  virtual_network_name = azurerm_virtual_network.terraformvnet.name
  address_prefixes     = [var.vnet_sub1]
}

resource "azurerm_public_ip" "publicip" {
    name                         = "myPublicIP"
    location                     = var.azure_location
    resource_group_name          = azurerm_resource_group.tfrg.name
    allocation_method            = "Dynamic"

}

resource "azurerm_network_interface" "terraform-nic" {
  name                = "terraform-nic"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_network_security_group" "ssh" {
  name                = "ssh"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name

  security_rule {
    name                       = "allow_SSH"
    description                = "Allow SSH access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "oracle1" {
  name                = "oracle1"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name

  security_rule {
    name                       = "allow_oracle"
    description                = "For oracle config"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1521"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "oracle2" {
  name                = "oracle1"
  location            = azurerm_resource_group.tfrg.location
  resource_group_name = azurerm_resource_group.tfrg.name

  security_rule {
    name                       = "allow_oracle2"
    description                = "For oracle config"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5502"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_linux_virtual_machine" "oraclevm" {
  name                = "oraclevm"
  resource_group_name = azurerm_resource_group.tfrg.name
  location            = azurerm_resource_group.tfrg.location
  size                = var.vm_size
  admin_username      = "azure"
  network_interface_ids = [
    azurerm_network_interface.terraform-nic.id
  ]

  admin_ssh_key {
    username   = "azure"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}