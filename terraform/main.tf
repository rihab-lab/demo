terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "1.0.4"
    }
  }

  backend "remote" {
    organization = "rbaorga"
    workspaces {
      name = "demo"
    }
  }
}
