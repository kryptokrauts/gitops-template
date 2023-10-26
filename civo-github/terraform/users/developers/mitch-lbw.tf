# note: uncomment the below to create a new developer, and be sure to
# adjust module name developer_one below to your developer's firstname_lastname.
# create as many developer module files as you have developer personnel.

# For Single Sign On: be sure to also add the new user to the developers-outputs.tf

module "mitch-lbw" {
  source = "../modules/user/github"

  acl_policies            = ["developer"]
  email                   = "mitch@kryptokrauts.com"
  first_name              = "Michel"
  github_username         = "mitch-lbw"
  team_id                 = data.github_team.developers.id
  last_name               = "Meier"
  username                = "mitch-lbw"
  user_disabled           = false
  userpass_accessor       = data.vault_auth_backend.userpass.accessor
}