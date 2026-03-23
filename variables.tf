locals {
  webapp_name = "webapp-${var.webapp_name}"
  tenant      = "tenant-${var.tenant}"
}

variable "cluster_name" {
  description = "Kubernetes cluster where to perform installation (must be one of the clusters (=/= context) in your kubectl config)"
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

variable "domain_zone" {
  description = "Domain zone (e.g. 'azure.platform.cosmotech.com' for AKS or 'onpremise.platform.cosmotech.com' for KOB)"
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

variable "cloud_provider" {
  description = "Cloud provider name where the deployment takes place"
  type        = string
  default     = "azure"
}