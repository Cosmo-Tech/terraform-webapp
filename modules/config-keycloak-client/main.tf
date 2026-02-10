terraform {
  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = "~> 5.5.0"
    }
  }
}


provider "keycloak" {
  url       = "https://${var.cluster_domain}/keycloak"
  client_id = "admin-cli"
  username  = data.kubernetes_secret.keycloak.data["keycloak_admin_user"]
  password  = data.kubernetes_secret.keycloak.data["keycloak_admin_password"]
}


data "kubernetes_secret" "keycloak" {
  metadata {
    namespace = "keycloak"
    name      = "keycloak-config"
  }
}


resource "keycloak_openid_client" "webapp" {
  enabled               = true
  realm_id              = var.tenant
  client_id             = "cosmotech-client-${var.webapp_name}"
  name                  = "cosmotech-client-${var.webapp_name}"
  access_type           = "PUBLIC"
  full_scope_allowed    = true
  standard_flow_enabled = true
  root_url              = "https://${var.cluster_domain}"
  base_url              = "https://${var.cluster_domain}/${var.tenant}/${var.webapp_name}"
  web_origins = [
    # CORS strict → plus sécurisé
    "https://${var.cluster_domain}"
  ]
  valid_redirect_uris = [
    "https://${var.cluster_domain}/${var.tenant}/${var.webapp_name}/sign-in",
    "https://${var.cluster_domain}/${var.tenant}/${var.webapp_name}/*"
  ]
}

resource "keycloak_generic_protocol_mapper" "realm_roles_mapper" {
  realm_id        = var.tenant
  client_id       = keycloak_openid_client.webapp.id
  name            = "realm roles"
  protocol        = "openid-connect"
  protocol_mapper = "oidc-usermodel-realm-role-mapper"
  config = {
    "id.token.claim" : "true",
    "access.token.claim" : "true",
    "claim.name" : "userRoles",
    "jsonType.label" : "String",
    "multivalued" : "true",
    "userinfo.token.claim" : "true",
    "introspection.token.claim" : "true"
  }
}

resource "keycloak_generic_protocol_mapper" "realm_roles_mapper_groups" {
  realm_id        = var.tenant
  client_id       = keycloak_openid_client.webapp.id
  name            = "groups"
  protocol        = "openid-connect"
  protocol_mapper = "oidc-usermodel-realm-role-mapper"
  config = {
    "id.token.claim" : "true",
    "access.token.claim" : "true",
    "claim.name" : "groups",
    "jsonType.label" : "String",
    "multivalued" : "true",
    "userinfo.token.claim" : "true",
    "introspection.token.claim" : "true"
  }
}