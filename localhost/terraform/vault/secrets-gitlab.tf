resource "vault_generic_secret" "gitlab_runner_secrets" {
  path = "secret/gitlab-runner"

  data_json = <<EOT
{
  "RUNNER_REGISTRATION_TOKEN": "${var.gitlab_runner_token}",
  "RUNNER_TOKEN": ""
}
EOT
}

resource "vault_generic_secret" "ci_secrets" {
  path = "secret/ci-secrets"

  data_json = jsonencode(
    {
      BASIC_AUTH_USER = "admin",
      BASIC_AUTH_PASS = random_password.chartmuseum_user_password.result,
      USERNAME = "kubefirst",
      PERSONAL_ACCESS_TOKEN = var.gitlab_token,
      SSH_PRIVATE_KEY = var.ssh_private_key,
    }
  )
}
resource "vault_generic_secret" "atlantis_secrets" {
  path = "secret/atlantis"

  data_json = jsonencode(
    {
      ARGOCD_AUTH_USERNAME = "admin",
      ARGOCD_INSECURE = "false",
      ARGOCD_SERVER = "argocd.<LOCAL_DNS>:443",
      ARGO_SERVER_URL = "argo.<LOCAL_DNS>:443",
      ATLANTIS_GITLAB_HOSTNAME = "gitlab.<LOCAL_DNS>",
      ATLANTIS_GITLAB_USER = "root",
      AWS_DEFAULT_REGION = "<LOCAL_DNS>",
      AWS_ROLE_TO_ASSUME = "arn:aws:iam::<LOCAL_DNS>:role/KubernetesAdmin",
      AWS_SESSION_NAME = "GitHubAction",
      GITLAB_BASE_URL = "https://gitlab.<LOCAL_DNS>",
      GITLAB_TOKEN = var.gitlab_token,
      ATLANTIS_GITLAB_TOKEN = var.gitlab_token,
      KUBECONFIG = "/.kube/config",
      TF_VAR_aws_account_id = "local",
      TF_VAR_aws_region = "local",
      TF_VAR_gitlab_runner_token = var.gitlab_runner_token,
      TF_VAR_gitlab_token = var.gitlab_token,
      TF_VAR_gitlab_url = "gitlab.<LOCAL_DNS>",
      TF_VAR_hosted_zone_id = var.hosted_zone_id,
      TF_VAR_hosted_zone_name = var.hosted_zone_name,
      TF_VAR_vault_addr = var.vault_addr,
      TF_VAR_vault_token = var.vault_token,
      VAULT_ADDR = "https://vault.<LOCAL_DNS>",
      VAULT_TOKEN = var.vault_token,
    }
  )
}
