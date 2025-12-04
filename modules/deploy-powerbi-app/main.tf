# Application powerbi
resource "azuread_application" "powerbi" {
  display_name     = "PowerBI App registrations For ${var.webapp_name}"
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "powerbi" {
  client_id                    = azuread_application.powerbi.client_id
  app_role_assignment_required = false
  depends_on                   = [azuread_application.powerbi]
}

resource "azuread_application_password" "powerbi_password" {
  display_name   = "powerbi_secret"
  application_id = azuread_application.powerbi.id
}

resource "kubernetes_secret" "powerbi" {
  metadata {
    name      = "${var.webapp_name}-powerbi-client"
    namespace = var.tenant
  }
  data = {
    "client_id"     = azuread_application.powerbi.client_id
    "client_secret" = azuread_application_password.powerbi_password.value
  }
}