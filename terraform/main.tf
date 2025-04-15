terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = ">=1.7.0"
    }
  }

  backend "remote" {
    organization = "rbaorga"
    workspaces {
      name = "demo"
    }
  }
}
