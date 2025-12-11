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
    ```hcl
    # Example 
    cloud_provider        = "azure"
    kubernetes_context    = "aks-dev-devops"
    cluster_domain        = "aks-dev-devops.azure.platform.cosmotech.com"
    tenant                = "test"
    webapp_name           = "business"
    organization_id       = "o-xxxxxxxx"
    azure_subscription_id = "xxxxxxxx_xxxx_xxxx_xxxx_xxxxxxxxxxxx"
    azure_entra_tenant_id = "xxxxxxxx_xxxx_xxxx_xxxx_xxxxxxxxxxxx"
    powerbi_app_deploy    = false
    ```
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
    * Azure
        * will ask for the access key of the Azure Storage of "cosmotechstates"
            * go to Azure > Azure Storage > "cosmotechstates" > Access keys
            * copy/paste "Key" from "key1" or "key2" in the terraform input
    * AWS
        * Not yet implemented 
    * GCP
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