## Cosmo Tech powerBi app registrations (optional
module "deploy-powerbi-app" {
  source = "./modules/deploy-powerbi-app"

  count       = var.powerbi_app_deploy ? 1 : 0
  webapp_name = local.webapp_name
  tenant      = local.tenant
}

## Keycloak client
module "chart-keycloak-client" {
  source = "./modules/config-keycloak-client"

  cluster_domain = var.cluster_domain
  tenant         = var.tenant
  webapp_name    = local.webapp_name
}

## Cosmo Tech Webapp
module "chart-cosmotech-webapp" {
  source = "./modules/chart-cosmotech-webapp"

  webapp_name           = local.webapp_name
  tenant                = local.tenant
  cluster_domain        = var.cluster_domain
  organization_id       = var.organization_id
  powerbi_app_deploy    = var.powerbi_app_deploy
  azure_entra_tenant_id = var.azure_entra_tenant_id

  depends_on = [
    module.deploy-powerbi-app
  ]
}


