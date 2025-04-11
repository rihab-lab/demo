variable "snowflake_account" {
  description = "Identifiant du compte Snowflake"
  type        = string
}

variable "snowflake_username" {
  description = "Nom d'utilisateur"
  type        = string
}

variable "snowflake_password" {
  description = "Mot de passe"
  type        = string
  sensitive   = true
}


variable "database_name" {
  description = "Nom de la base de données"
  type        = string
  default     = "MON_DATABASE"
}
