resource "random_pet" "{{ name }}_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "{{ name }}_rg" {
  location = var.resource_group_location
  name     = random_pet.{{ name }}_name.id
}

# Create virtual network
resource "azurerm_virtual_network" "{{ name }}_network" {
  name                = "{{ name }}Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.{{ name }}_rg.location
  resource_group_name = azurerm_resource_group.{{ name }}_rg.name
}

# Create subnet
resource "azurerm_subnet" "{{ name }}_subnet" {
  name                 = "{{ name }}Subnet"
  resource_group_name  = azurerm_resource_group.{{ name }}_rg.name
  virtual_network_name = azurerm_virtual_network.{{ name }}_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "{{ name }}_public_ip" {
  name                = "{{ name }}PublicIP"
  location            = azurerm_resource_group.{{ name }}_rg.location
  resource_group_name = azurerm_resource_group.{{ name }}_rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "{{ name }}_nsg" {
  name                = "{{ name }}NetworkSecurityGroup"
  location            = azurerm_resource_group.{{ name }}_rg.location
  resource_group_name = azurerm_resource_group.{{ name }}_rg.name
}

resource "azurerm_network_security_rule" "{{ name }}_security_ssh" {
  name                       = "SSH"
  priority                   = 1010
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefixes    = ["77.165.196.232", "192.87.139.123",{% if ssh_ip_whitelist %} "{{ ssh_ip_whitelist}}"{%endif%}]
  destination_address_prefix = "*"
  resource_group_name        = azurerm_resource_group.{{ name }}_rg.name
  network_security_group_name = azurerm_network_security_group.{{ name }}_nsg.name
}
{% if security_policy == "internal" %}
resource "azurerm_network_security_rule" "{{ name }}_security_https" {
  name                       = "HTTPS"
  priority                   = 1020
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefixes    = ["77.165.196.232", "192.87.139.123"]
  destination_address_prefix = "*"
  resource_group_name        = azurerm_resource_group.{{ name }}_rg.name
  network_security_group_name = azurerm_network_security_group.{{ name }}_nsg.name
}

resource "azurerm_network_security_rule" "{{ name }}_security_http" {
  name                       = "SSH_DENY"
  priority                   = 1030
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "80"
  source_address_prefixes    = ["77.165.196.232", "192.87.139.123"]
  destination_address_prefix = "*"
  resource_group_name        = azurerm_resource_group.{{ name }}_rg.name
  network_security_group_name = azurerm_network_security_group.{{ name }}_nsg.name
}
{% elif security_policy == "external" %}
resource "azurerm_network_security_rule" "{{ name }}_security_https" {
  name                       = "HTTPS"
  priority                   = 1020
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefixes    = "*"
  destination_address_prefix = "*"
  resource_group_name        = azurerm_resource_group.{{ name }}_rg.name
  network_security_group_name = azurerm_network_security_group.{{ name }}_nsg.name
}

resource "azurerm_network_security_rule" "{{ name }}_security_http" {
  name                       = "SSH_DENY"
  priority                   = 1030
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "80"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name        = azurerm_resource_group.{{ name }}_rg.name
  network_security_group_name = azurerm_network_security_group.{{ name }}_nsg.name
}

{% endif %}

resource "azurerm_network_security_rule" "{{ name }}_security_ssh_deny" {
  name                       = "HTTP"
  priority                   = 2000
  direction                  = "Inbound"
  access                     = "Deny"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name        = azurerm_resource_group.{{ name }}_rg.name
  network_security_group_name = azurerm_network_security_group.{{ name }}_nsg.name
}

# Create network interface
resource "azurerm_network_interface" "{{ name }}_nic" {
  name                = "{{ name }}NIC"
  location            = azurerm_resource_group.{{ name }}_rg.location
  resource_group_name = azurerm_resource_group.{{ name }}_rg.name

  ip_configuration {
    name                          = "{{ name }}_nic_configuration"
    subnet_id                     = azurerm_subnet.{{ name }}_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.{{ name }}_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "{{ name }}" {
  network_interface_id      = azurerm_network_interface.{{ name }}_nic.id
  network_security_group_id = azurerm_network_security_group.{{ name }}_nsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.{{ name }}_rg.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "{{ name }}_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.{{ name }}_rg.location
  resource_group_name      = azurerm_resource_group.{{ name }}_rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create (and display) an SSH key
resource "tls_private_key" "{{ name }}_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "{{ name }}_vm" {
  name                  = "{{ name }}"
  location              = azurerm_resource_group.{{ name }}_rg.location
  resource_group_name   = azurerm_resource_group.{{ name }}_rg.name
  network_interface_ids = [azurerm_network_interface.{{ name }}_nic.id]
  size                  = "{{ vm_size }}"

  os_disk {
    name                 = "{{ name }}Disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22.04-LTS"
    version   = "latest"
  }

  computer_name                   = "{{ vm_name }}"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.{{ name }}_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.{{ name }}_storage_account.primary_blob_endpoint
  }
}
