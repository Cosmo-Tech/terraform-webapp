# This file allows to fix defaults values, and also allow to override them from terraform.tfvars, CLI arguments or TF_VAR env variables.


# Registry
variable "registry" { default = "registry.cosmotech.com" }
variable "chart_prefix_product" { default = "product-charts/" }
variable "image_prefix_product" { default = "product/" }

# Cosmo Tech Webapp
variable "cosmotech_business_webapp_chart_name" { default = "cosmotech-business-webapp" }
variable "cosmotech_business_webapp_chart_tag" { default = "0.3.0" }

variable "cosmotech_business_webapp_image_repository_server" { default = "cosmotech-business-webapp-server" }
variable "cosmotech_business_webapp_image_tag_server" { default = "v7.4.0-vanilla" }
variable "cosmotech_business_webapp_image_pull_secret_server" { default = "registry-auth-cosmotech" }

variable "cosmotech_business_webapp_image_repository_functions" { default = "cosmotech-business-webapp-functions" }
variable "cosmotech_business_webapp_image_tag_functions" { default = "v7.4.0-vanilla" }
variable "cosmotech_business_webapp_image_pull_secret_functions" { default = "registry-auth-cosmotech" }

