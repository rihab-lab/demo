variable "snowflake_account" {
  type        = string
  description = "Nom du compte Snowflake (exemple : xyz12345.us-east-1)"
}

variable "snowflake_user" {
  type        = string
  description = "Nom d'utilisateur Snowflake"
}

variable "snowflake_password" {
  type        = string
  sensitive   = true
  description = "Mot de passe Snowflake"
}
