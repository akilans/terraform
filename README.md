# Terraform for Beginners
	

# Why Terraform

	* Some automation tools and services are provided by cloud vendors themselves. AWS, for example, offers CloudFormation for provisioning AWS resources programmatically, Microsoft has its Automation, and OpenStack has Heat. But all those services come with vendor lock: they’ll only deploy within their own environments. But if you’re looking for multi-vendor solutions, then you might be better off with HashiCorp’s open source Terraform,which can provision servers and services from just about any cloud platform
	
	* Terraform is cloud-agnostic. By using a single configuration file, you can deploy your application on resources from multiple cloud providers
	
	* You can provide a sample Terraform configuration file to create, provision and bootstrap a demo on cloud providers like AWS to your end users and clients, who could also quickly tweak resource parameters according to their needs
	
	* easy to create Identical & Disposal environments

	
	* Configuration Management vs Orchestration - Chef, Puppet, Ansible, and SaltStack are all “configuration management” tools, which means they are designed to install and manage software on existing servers. CloudFormation and Terraform are “orchestration tools”, which means they are designed to provision the servers themselves, leaving the job of configuring those servers to other tools.
	
	* Mutable Infrastructure vs Immutable Infrastructure - Servers managed by chef, Ansible, puppet are leads to configuration drift. They are mutable Infrastructure. But terraform is creating instance from scratch which is Immutable
	
	* Procedural vs Declarative - 
	
	* Client/Server Architecture vs Client-Only Architecture - Most of the tools for configuration management are Client-Server Architecture. But terraform is a client onlyu architecture
	

# AWS - Terraform Configuration

	* refer aws-test.tf - It create ubuntu EC2 instance on AWS with apache2 shell provisioning
	* Create terraform.tfvars file with the following content
		access_key = "dsjfjsfsdfkdsbkf"
		secret_key = "ksdfksjfk"
		region = "ap-south-1"
