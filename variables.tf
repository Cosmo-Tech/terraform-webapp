locals {
  webapp_name = "webapp-${var.webapp_name}"
  tenant      = "tenant-${var.tenant}"
}

variable "kubernetes_context" {
  description = "Kubernetes context (= the cluster) where to perform installation"
  type        = string
}

variable "tenant" {
  description = "Cosmo Tech tenant name"
  type        = string
}

variable "webapp_name" {
  description = "Webapp name"
  type        = string
}

variable "cluster_domain" {
  description = "[temporary] Cluster domain"
  type        = string
}

variable "organization_id" {
  description = "Organization ID to map with the Webapp"
  type        = string
}

variable "powerbi_app_deploy" {
  description = "This will be optional in case the client needs Power BI"
  type        = bool
  default     = false
}

variable "azure_entra_tenant_id" {
  description = "Azure Entra tenant ID"
  type        = string
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "cloud_provider" {
  description = "Cloud provider name where the deployment takes place"
  type        = string
  default = "azure"
}