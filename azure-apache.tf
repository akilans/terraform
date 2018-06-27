provider "azurerm" {
  subscription_id = "SUB-ID"
  client_id       = "CLIENT-ID"
  client_secret   = "CLIENT-SECRET-KEY"
  tenant_id       = "TENANT-ID"
}

variable "location" { default = "Central India" }

# Create a resource group
resource "azurerm_resource_group" "test" {
  name     = "terraform"
  location = "${var.location}"
}

resource "azurerm_public_ip" "test" {
  name                         = "TerraformTestPublicIp"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.test.name}"
  public_ip_address_allocation = "static"

  tags {
    environment = "Production"
  }
}
 
resource "azurerm_virtual_network" "test" {
  name                = "terraform-vnet"
  address_space       = ["172.16.1.0/24"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
}
 
resource "azurerm_subnet" "test" {
  name                 = "default"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "172.16.1.0/24"
}

resource "azurerm_network_security_group" "test" {
  name                = "terraformSecurityGroup"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
}

resource "azurerm_network_security_rule" "test" {
  name                        = "apache2Access"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = [22,80]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.test.name}"
  network_security_group_name = "${azurerm_network_security_group.test.name}"
}

resource "azurerm_network_interface" "test" {
  name                = "terraformubuntu123"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  network_security_group_id = "${azurerm_network_security_group.test.id}"
  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.test.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.test.id}"
  }
}
 
 
resource "azurerm_virtual_machine" "test" {
  name                  = "Terraform-Ubuntu"
  location              = "Central India"
  resource_group_name   = "${azurerm_resource_group.test.name}"
  network_interface_ids = ["${azurerm_network_interface.test.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }


  storage_os_disk {
    name          = "myosdisk1"
    caching       = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "terraform-ubuntu"
    admin_username = "akilan"
    admin_password = "akilan@12345"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "Production"
  }
  
  connection {
    type     = "ssh"
    host = "${azurerm_public_ip.test.ip_address}"
    user     = "akilan"
    password = "akilan@12345"
  }
  
  provisioner "remote-exec" {
    inline = [<<EOF
    
	  sudo apt-get update
	  sudo apt-get -y install apache2
      sudo chown -hR akilan:akilan /var/www/html/

    EOF
   ]
  }
  
  provisioner "file" {
    source      = "terraform.html"
    destination = "/var/www/html/terraform.html"
  }
  
  
}

output "ip_address" {
  value = "${azurerm_public_ip.test.ip_address}"
}
