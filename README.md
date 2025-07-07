Terraform Azure Hub-Spoke Network Infrastructure
This project implements Infrastructure as Code (IaC) using Terraform to deploy a robust Azure Hub-Spoke network topology. It is designed with scalability, security, and maintainability in mind — ideal for enterprise-grade cloud environments.

The solution follows CI/CD best practices, enabling automated, consistent, and repeatable provisioning and updates of the infrastructure using tools like GitHub Actions or Azure DevOps.

Key Features
Hub Virtual Network: Includes Azure Firewall, VPN Gateway, and custom DNS server

Spoke Virtual Networks: Segregated networks for workloads (e.g., web apps, VMs)

Security: Centralized traffic filtering using Azure Firewall with application rules

Private DNS Zones: Linked to VNets for internal name resolution

User-Defined Routes (UDRs): Control traffic flow via firewall and gateway

Terraform Best Practices: Modular design, variable definitions, and remote state support

CI/CD Integration Ready: Easily connect with GitHub Actions, Azure DevOps, etc.

Deployment Overview
Write Terraform configuration files to define your infrastructure

Run terraform init to initialize the working directory

Use terraform plan to review the proposed changes

Apply the infrastructure with terraform apply

Automate all the above in a CI/CD pipeline for production-ready deployments

Prerequisites
An Azure subscription with sufficient permissions

Terraform CLI v1.0+ installed

Azure CLI installed and authenticated (az login)

(Optional) A GitHub repository for source control and CI/CD integration

How to Use
Clone this repository

bash
Copy
Edit
git clone https://github.com/xsonali/devjobs.git
cd devjobs
Customize configuration

Edit terraform.tfvars to set your desired values

Or use environment variables for sensitive data

Deploy with Terraform

bash
Copy
Edit
terraform init
terraform plan
terraform apply
CI/CD Option

Set up a GitHub Actions or Azure DevOps pipeline to automate the above steps

Disclaimer:
Use this project at your own risk. The author is not responsible for any errors, misconfigurations, data loss, or misunderstandings that may arise from using or modifying this code.

