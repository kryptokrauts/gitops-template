# every developer that is added to the platform will need to have their ID
# added to this list so that its client id is added to the group in vault
output "vault_identity_entity_ids" {
  value = [
    module.mitch-lbw.vault_identity_entity_id,
  ]
}