locals {
  webapp_powerbi_app_client_id = try(data.kubernetes_secret.powerbi.data["client_id"], "")
  webapp_powerbi_app_secret    = try(data.kubernetes_secret.powerbi.data["client_secret"], "")

  chart_values_file = templatefile("${path.module}/values.yaml", local.chart_values)
  chart_values = {
    CLUSTER_DOMAIN              = var.cluster_domain
    WEBAPP_NAME                 = var.webapp_name
    NAMESPACE                   = var.tenant
    ORGANIZATION_ID             = var.organization_id
    SUPERSET_SUPERUSER_PASSWORD = try(data.kubernetes_secret.superset.data["superset-password"], "")
    COSMOTECH_API_URL           = "https://${var.cluster_domain}/${var.tenant}/api"
    POWERBI_APP_TENANT_ID       = var.azure_entra_tenant_id
    POWERBI_APP_CLIENT_ID       = local.webapp_powerbi_app_client_id
    POWERBI_APP_SECRET          = local.webapp_powerbi_app_secret
    IMAGE_TAG                   = var.image_tag
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
    name      = "superset"
    namespace = "superset"
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
  repository = var.chart_repository
  chart      = var.chart_name
  version    = var.chart_tag

  values = [
    local.chart_values_file
  ]

  force_update  = true
  recreate_pods = true
  # replace       = true

  lifecycle {
    replace_triggered_by = [
      terraform_data.helm_release_trigger,
    ]
  }

  depends_on = [
    var.tenant,
  ]
}

resource "terraform_data" "helm_release_trigger" {
  input = {
    version      = var.chart_tag
    values       = local.chart_values_file
    values_sha1  = sha1(local.chart_values_file)
    helm_release = data.kubernetes_resources.helm_release_secret
  }
}

data "kubernetes_resources" "helm_release_secret" {
  api_version    = "v1"
  kind           = "Secret"
  label_selector = "owner=helm,name=${var.webapp_name}"
}

