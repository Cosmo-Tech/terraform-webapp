![Static Badge](https://img.shields.io/badge/Cosmo%20Tech-%23FFB039?style=for-the-badge)
![Static Badge](https://img.shields.io/badge/webapp-%23f8f8f7?style=for-the-badge)


# Cosmo Tech webapp deployment

## Requirements
* working Kubernetes cluster (with admin access)
* Linux (Debian/Ubuntu) workstation with:
    * [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
    * [jq](https://jqlang.org/)
* if Azure: [azure-cli](https://github.com/Azure/azure-cli) installed and ready to use
* if AWS: [aws-cli](https://github.com/aws/aws-cli) installed and ready to use

## How to
* **Clone & open the repository**
    ```
    git clone https://github.com/Cosmo-Tech/terraform-webapp.git
    ```
    ```
    cd terraform-webapp
    ```
* **Deploy**
    * Fill `terraform-cluster/terraform.tfvars` variables according to your needs<br>
    * run pre-configured script
        > ℹ️ comment/uncomment the terraform apply line at the end to get a plan without deploy anything
        * **Linux**
            ```bash
            ./_run-terraform.sh
            ```
        * **Windows**
            ```powershell
            ./_run-terraform.ps1
            ```
    * Backend target notes
        * **Azure**
            * The run script generates a `target.tf` file from `targets/azure.target.tf`
            * Terraform uses the `azurerm` backend for the remote state
        * **KOB / On-premise**
            * The run script generates a `target.tf` file from `targets/kob.target.tf`
            * Set `state_host` in `terraform.tfvars`
            * Export backend credentials before running Terraform:
                * `TF_HTTP_USERNAME`
                * `TF_HTTP_PASSWORD`
        * **AWS**
            * Not yet implemented
        * **GCP**
            * Not yet implemented

## Developpers
* modules
    * **terraform-webapp**
        * install Cosmo Tech webapp in a tenant created from terraform-tenant
## Note 
There is a module that can deploy a Power BI App Registration if you are using Power BI.  
However, **by default, Superset is configured instead**, so the Power BI app is not deployed unless explicitly enabled.

In `terraform.tfvars`, the variable controlling this feature is set to `false` by default:

```hcl
powerbi_app_deploy = false
```
<br>
<br>
<br>

Made with :heart: by Cosmo Tech DevOps team