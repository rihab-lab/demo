variable "azure_tenant_id" {
  description = "Azure Entra ID (anciennement Azure Active Directory Tenant ID)"
  type        = string
}

variable "azure_container_url" {
  description = "URL du conteneur Azure Blob (ex: azure://...)"
  type        = string
}

variable "enable_pipes" {
  type    = bool
  default = false
}