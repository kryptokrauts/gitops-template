# note: uncomment the below to create a new admin, and be sure to
# adjust module name admin_one below to your admin's firstname_lastname.
# create as many admin modules files as you have admin personnel.

# For Single Sign On: be sure to also add the new user to the admins-outputs.tf

module "marc0olo" {
  source = "../modules/user/github"

  acl_policies            = ["admin"]
  email                   = "marco@kryptokrauts.com"
  first_name              = "Marco"
  github_username         = "marc0olo"
  last_name               = "Walz"
  team_id                 = data.github_team.admins.id
  username                = "marc0olo"
  user_disabled           = false
  userpass_accessor       = data.vault_auth_backend.userpass.accessor
}