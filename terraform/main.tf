terraform {
  #https://developer.hashicorp.com/terraform/language/providers/requirements
  required_providers {
    snowflake = {                         #local name module
      source = "Snowflake-Labs/snowflake" #(NAMESPACE/TYPE for terraform registry)
      #version constraint(provider versions module is compatible with)
      # https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest
      version = "1.0.4"
    }
  }

  #https://developer.hashicorp.com/terraform/language/backend/remote
  #Backend specifies mechanism storing Terraform state files
  #cannot configure cloud block when configuration contains backend configuration for storing state data.
  backend "remote" {
    organization = "rbaorga"
    workspaces {
     
      prefix = "demo" #To use multiple remote workspaces
    }
  }
}

provider "snowflake" {
  preview_features_enabled = ["snowflake_table_resource"] # mandatory to use preview resource "table creation"
  role                     = "SYSADMIN"
}