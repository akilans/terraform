# Terraform for Beginners
	

# Why Terraform

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
