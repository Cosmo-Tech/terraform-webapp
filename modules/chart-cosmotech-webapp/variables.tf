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

# variable "chart_release" {
#   type = string
# }

variable "webapp_name" {
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

variable "azure_entra_tenant_id" {
  description = "Azure Entra tenant ID"
  type        = string
}
