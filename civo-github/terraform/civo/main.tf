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
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.19.0"
    }
  }
}
provider "civo" {
  region = "<CLOUD_REGION>"
}

locals {
  cluster_name = "<CLUSTER_NAME>"
  kube_config_filename = "../../../kubeconfig"
}

resource "civo_network" "kubefirst" {
  label = local.cluster_name
}

resource "civo_firewall" "kubefirst" {
  name                 = local.cluster_name
  network_id           = civo_network.kubefirst.id
  create_default_rules = true
}

resource "civo_kubernetes_cluster" "kubefirst" {
  name        = local.cluster_name
  network_id  = civo_network.kubefirst.id
  firewall_id = civo_firewall.kubefirst.id
  pools {
    label      = local.cluster_name
    size       = "g4s.kube.medium"
    node_count = 4
  }
}

# resource "civo_kubernetes_node_pool" "kubefirst-standard-large" {
#   cluster_id = civo_kubernetes_cluster.kubefirst.id
#   label = "kubefirst-standard-large"
#   node_count = 1
#   size = "g4s.kube.large"
#   region = "<CLOUD_REGION>"
# }

resource "civo_kubernetes_node_pool" "workflows-standard-large" {
  cluster_id = civo_kubernetes_cluster.kubefirst.id
  label = "workflows-standard-large"
  node_count = 1
  size = "g4s.kube.large"
  region = "<CLOUD_REGION>"
  labels = {
    purpose  = "workflows"
  }
  taint {
    key = "workflow-executor"
    value = "true"
    effect = "NoSchedule"
  }
}

# resource "civo_kubernetes_node_pool" "workflows-performance-small" {
#   cluster_id = civo_kubernetes_cluster.kubefirst.id
#   label = "workflows-performance-small"
#   node_count = 1
#   size = "g4p.kube.small"
#   region = "<CLOUD_REGION>"
#   labels = {
#     purpose  = "workflows"
#   }
#   taint {
#     key = "workflow-executor"
#     value = "true"
#     effect = "NoSchedule"
#   }
# }

resource "local_file" "kubeconfig" {
  content  = civo_kubernetes_cluster.kubefirst.kubeconfig
  filename = local.kube_config_filename
}
