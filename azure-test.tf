
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
 
resource "azurerm_network_interface" "test" {
  name                = "terraformubuntu123"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.test.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.test.id}"
  }
}
 
resource "azurerm_storage_account" "test" {
  name                = "helloworld25662"
  resource_group_name = "${azurerm_resource_group.test.name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"
}
 
resource "azurerm_storage_container" "test" {
  name                  = "helloworld"
  resource_group_name   = "${azurerm_resource_group.test.name}"
  storage_account_name  = "${azurerm_storage_account.test.name}"
  container_access_type = "private"
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
    vhd_uri       = "${azurerm_storage_account.test.primary_blob_endpoint}${azurerm_storage_container.test.name}/myosdisk1.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
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
		sudo apt-get -y install openjdk-8-jre-headless
		sudo echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/' >> ~/.bashrc
		source ~/.bashrc
		curl -O http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.15/bin/apache-tomcat-8.5.15.tar.gz
		sudo mkdir /opt/tomcat/
		sudo tar xzvf apache-tomcat-8.5.15.tar.gz -C /opt/tomcat/
		sudo groupadd tomcat
		sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
		sudo chown -hR tomcat:tomcat /opt/tomcat/apache-tomcat-8.5.15/
		sudo chmod +x /opt/tomcat/apache-tomcat-8.5.15/bin/
		sudo echo 'export CATALINA_HOME=/opt/tomcat/apache-tomcat-8.5.15/' >> ~/.bashrc
		sudo echo 'export CATALINA_BASE=/opt/tomcat/apache-tomcat-8.5.15/' >> ~/.bashrc
		source ~/.bashrc
		sudo rm /opt/tomcat/apache-tomcat-8.5.15/conf/tomcat-users.xml

    EOF
   ]
  }
  
   provisioner "file" {
    source      = "tomcat-users.xml"
    destination = "/home/akilan/tomcat-users.xml"
  }
  
  provisioner "remote-exec" {
    inline = [<<EOF
    		
    		sudo mv /home/akilan/tomcat-users.xml /opt/tomcat/apache-tomcat-8.5.15/conf/
		sudo /opt/tomcat/apache-tomcat-8.5.15/bin/startup.sh

    EOF
   ]
  }
  
}

output "ip_address" {
  value = "${azurerm_public_ip.test.ip_address}"
}
