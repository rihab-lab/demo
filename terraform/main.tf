terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = ">= 0.67.0"
    }
  }

  backend "remote" {
    organization = "rbaorga"
    workspaces {
      name = "demo"
    }
  }
}
