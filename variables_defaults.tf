# This file allows to fix defaults values, and also allow to override them from terraform.tfvars, CLI arguments or TF_VAR env variables.


# Registry
variable "image_registry" { default = "cgr.dev" }
variable "image_registry_auth_secret" { default = "registry-auth-cgrdev" }


# Cosmo Tech Webapp
variable "cosmotechwebapp_chart_name" { default = "cosmotech-business-webapp" }
variable "cosmotechwebapp_chart_repository" { default = "https://cosmo-tech.github.io/helm-charts" }
variable "cosmotechwebapp_chart_tag" { default = "0.3.0" }
variable "cosmotechwebapp_image_repository_server" { default = "ghcr.io/cosmo-tech/azure-sample-webapp" }
variable "cosmotechwebapp_image_tag_server" { default = "v7.0.4-vanilla" }
variable "cosmotechwebapp_image_repository_functions" { default = "ghcr.io/cosmo-tech/azure-sample-webapp" }
variable "cosmotechwebapp_image_tag_functions" { default = "v7.0.4-vanilla" }

