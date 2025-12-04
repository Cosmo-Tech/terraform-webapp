locals {
  webapp_powerbi_app_client_id = try(data.kubernetes_secret.powerbi.data["client_id"], "")
  webapp_powerbi_app_secret    = try(data.kubernetes_secret.powerbi.data["client_secret"], "")
  chart_values = {
    "CLUSTER_DOMAIN"              = var.cluster_domain
    "WEBAPP_NAME"                 = var.webapp_name
    "NAMESPACE"                   = var.tenant
    "ORGANIZATION_ID"             = var.organization_id
    "SUPERSET_SUPERUSER_PASSWORD" = try(data.kubernetes_secret.superset.data["superset-password"], "")
    "COSMOTECH_API_URL"           = "https://${var.cluster_domain}/${var.tenant}/api"
    "POWERBI_APP_TENANT_ID"       = var.azure_entra_tenant_id
    "POWERBI_APP_CLIENT_ID"       = local.webapp_powerbi_app_client_id
    "POWERBI_APP_SECRET"          = local.webapp_powerbi_app_secret
  }
}


resource "kubernetes_config_map" "webapp" {
  metadata {
    namespace = var.tenant
    name      = "${var.webapp_name}-server-configmap-config"
  }

  data = {
    "AssetCopyMapping.json"      = templatefile("${path.module}/AssetCopyMapping.json", local.chart_values)
    "ContentSecurityPolicy.json" = templatefile("${path.module}/ContentSecurityPolicy.json", local.chart_values)
    "GlobalConfiguration.json"   = templatefile("${path.module}/GlobalConfiguration.json", local.chart_values)
  }
}

data "kubernetes_secret" "superset" {
  metadata {
    name = "superset"
    # Here I use the same Kubernetes namespace, but before the release of Superset 6
    # I think we have two options:
    # - We can deploy superset in each namespace
    # - After the release 6, it will be centralized in the cluster
    namespace = var.tenant
  }
}

data "kubernetes_secret" "powerbi" {
  metadata {
    name      = "${var.webapp_name}-powerbi-client"
    namespace = var.tenant
  }
}

resource "helm_release" "webapp" {
  namespace  = var.tenant
  name       = var.webapp_name
  repository = "https://cosmo-tech.github.io/helm-charts"
  chart      = "cosmotech-business-webapp"
  version    = "0.2.2"
  values = [
    templatefile("${path.module}/values.yaml", local.chart_values)
  ]

  reset_values = true
  replace      = true
  force_update = true

  depends_on = [
    kubernetes_config_map.webapp,
  ]
}
