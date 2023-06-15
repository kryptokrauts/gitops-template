data "civo_size" "small" {
  filter {
    key      = "name"
    values   = ["db.small"]
    match_by = "re"
  }
  filter {
    key    = "type"
    values = ["database"]
  }
}

data "civo_database_version" "postgresql" {
  filter {
    key    = "engine"
    values = ["postgresql"]
  }
}

resource "civo_database" "vault" {
  count = lower(local.cloud_region) != "nyc1" ? 1 : 0

  name    = "vault-<CLUSTER_NAME>"
  size    = element(data.civo_size.small.sizes, 0).name
  nodes   = 2
  engine  = element(data.civo_database_version.postgresql.versions, 0).engine
  version = element(data.civo_database_version.postgresql.versions, 0).version
}
