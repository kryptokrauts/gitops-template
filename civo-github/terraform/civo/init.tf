terraform {
  backend "s3" {
    bucket   = "<KUBEFIRST_STATE_STORE_BUCKET>"
    key      = "terraform/civo/terraform.tfstate"
    endpoint = "https://objectstore.<CLOUD_REGION>.civo.com"

    region = "<CLOUD_REGION>"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
  required_providers {
    civo = {
      source = "civo/civo"
    }
  }
}

provider "civo" {
  region = "<CLOUD_REGION>"
}
