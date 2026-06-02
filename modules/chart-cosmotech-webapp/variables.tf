variable "tenant" {
  type = string
}

variable "chart_repository" {
  type = string
}

variable "chart_name" {
  type = string
}

variable "chart_tag" {
  type = string
}

variable "chart_release" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "cluster_domain" {
  type = string
}

variable "organization_id" {
  type = string
}

variable "powerbi_app_deploy" {
  description = "This will be optional in case the client needs Power BI"
  type        = bool
}

variable "azure_entra_tenant_id" {
  description = "Azure Entra tenant ID"
  type        = string
}
