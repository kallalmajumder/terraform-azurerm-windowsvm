resource "azurerm_resource_group" "RG" {
  name = "terraform-rg"
  location = "centralindia"
}
resource "azurerm_virtual_network" "vNET" {
  name = "terraform-vNET"
  location = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  address_space = [ "20.0.0.0/16" ]
  #dns_servers = [ "20.0.0.4" ]
}
resource "azurerm_subnet" "subnet" {
  name = "terraform-subnet"
  address_prefixes = [ "20.0.0.0/24" ]
  virtual_network_name = azurerm_virtual_network.vNET.name
  resource_group_name = azurerm_resource_group.RG.name
}
resource "azurerm_public_ip" "publicIP" {
  for_each              = var.vm_name
  name                  = "terraform-publicIP-${each.key}"
  allocation_method     = "Dynamic"
  resource_group_name   = azurerm_resource_group.RG.name
  location              = azurerm_resource_group.RG.location
  domain_name_label     = "terraform-${each.key}"
}
resource "azurerm_network_interface" "NIC" {
  for_each = var.vm_name
  name = "terraform-nic-${each.key}"
  location = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  ip_configuration {
    name = "privateIP-${each.key}"
    private_ip_address_allocation = "Dynamic"
    subnet_id = azurerm_subnet.subnet.id
    public_ip_address_id = "${azurerm_public_ip.publicIP[each.key].id}"
  }
}
resource "azurerm_network_security_group" "NSG" {
  name = "terraform-nsg"
  location = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
}
resource "azurerm_network_security_rule" "in-rule" {
  name                        = "test123"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name = azurerm_resource_group.RG.name
  network_security_group_name = azurerm_network_security_group.NSG.name
}

resource "azurerm_network_security_rule" "out-rule" {
  name                        = "test1234"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name = azurerm_resource_group.RG.name
  network_security_group_name = azurerm_network_security_group.NSG.name
}


resource "azurerm_subnet_network_security_group_association" "nic-nsg" {
  network_security_group_id = azurerm_network_security_group.NSG.id
  subnet_id = azurerm_subnet.subnet.id
}