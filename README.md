Terraform Azure Hub-Spoke Network Infrastructure
This project implements Infrastructure as Code (IaC) using Terraform to deploy an Azure Hub-Spoke network topology. The infrastructure is designed for scalable, secure, and manageable Azure environments.

The deployment follows CI/CD best practices to automate provisioning and updates of the cloud infrastructure, ensuring consistent and repeatable deployments.

Key Features
Hub virtual network with firewall, VPN gateway, and DNS server

Multiple spoke virtual networks for workloads, e.g., web apps, VMs

Network security through Azure Firewall with application rules

Private DNS zones linked to virtual networks for name resolution

User Defined Routes (UDRs) to route traffic via firewall and gateways

Use of Terraform modules, variables, and state management

Integration ready for CI/CD pipelines (GitHub Actions, Azure DevOps, etc.)

Deployment Overview
Write Terraform configuration files describing the infrastructure components.

Use terraform init to initialize the working directory.

Run terraform plan to review infrastructure changes.

Execute terraform apply to provision resources in Azure.

Automate these steps through CI/CD pipelines for reliable deployments.

Prerequisites
Azure subscription with appropriate permissions

Terraform v1.0 or later installed

Azure CLI installed and logged in

Optional: GitHub repo configured for source control and pipeline automation

How to Use
Clone the repo

Customize variables in terraform.tfvars or environment variables

Run Terraform commands or configure your CI/CD pipeline to deploy