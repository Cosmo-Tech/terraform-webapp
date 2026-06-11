locals {
  cluster_domain = "${var.cluster_name}.${var.domain_zone}"
  tenant         = "tenant-${var.tenant}"
  webapp_name    = "webapp-${var.webapp_name}"
}


## Cosmo Tech PowerBi app registrations (optional)
module "deploy-powerbi-app" {
  source = "./modules/deploy-powerbi-app"

  count = var.powerbi_app_deploy ? 1 : 0

  tenant      = local.tenant
  webapp_name = local.webapp_name
}


## Keycloak client for the Webapp
module "config-keycloak-client" {
  source = "./modules/config-keycloak-client"

  cluster_domain = local.cluster_domain
  tenant         = local.tenant
  webapp_name    = local.webapp_name
}


## Cosmo Tech Webapp Helm Chart
module "chart-cosmotech-webapp" {
  source = "./modules/chart-cosmotech-webapp"

  tenant = local.tenant

  chart_repository = var.cosmotechwebapp_chart_repository
  chart_name       = var.cosmotechwebapp_chart_name
  chart_tag        = var.cosmotechwebapp_chart_tag
  # chart_release    = local.webapp_name
  webapp_name                = local.webapp_name
  image_repository_server    = var.cosmotechwebapp_image_repository_server
  image_tag_server           = var.cosmotechwebapp_image_tag_server
  image_repository_functions = var.cosmotechwebapp_image_repository_functions
  image_tag_functions        = var.cosmotechwebapp_image_tag_functions

  cluster_domain        = local.cluster_domain
  organization_id       = var.organization_id
  azure_entra_tenant_id = var.azure_entra_tenant_id

  depends_on = [
    module.deploy-powerbi-app
  ]
}
