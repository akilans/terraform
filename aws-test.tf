
variable "access_key" { 
	default = "" 
}

variable "secret_key" { 
	default = "" 
}

variable "region" { 
	default = "" 
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "example" {
  ami           = "ami-c2ee9dad"
  instance_type = "t2.micro"
  key_name = "aws-ec2-keypair"
  
  connection {
	  user = "ubuntu"
	  private_key="${file("/home/akilan/.ssh/aws-ec2-keypair.pem")}"
	  agent = true
	  timeout = "3m"
  } 

  provisioner "remote-exec" {
    inline = [<<EOF
    
	    sudo apt-get update
	    sudo apt-get -y install apache2
	    sudo /etc/init.d/apache2 start

    EOF
   ]
 }
  
}

