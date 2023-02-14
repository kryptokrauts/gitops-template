terraform {
  backend "s3" {
    bucket   = "k1-state-store-feedkray-1-samj0n"
    key      = "terraform/users/tfstate.tf"
    endpoint = "https://objectstore.NYC1.civo.com"

    region = "NYC1"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.3.0"
    }
  }
}

data "github_team" "admins" {
  slug = "admins"
}

data "github_team" "developers" {
  slug = "developers"
}
