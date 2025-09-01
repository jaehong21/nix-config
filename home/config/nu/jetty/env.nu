# XDG environment variables
let username = (whoami)
$env.XDG_CONFIG_HOME = $"/Users/($username)/.config"
$env.XDG_DATA_HOME = $"/Users/($username)/.local/share"

# ENV variables
$env.AWS_PROFILE = "default"
$env.GITHUB_ACTOR = "jaehong21"

# Secrets
let SECRETS_PATH = ($env.XDG_CONFIG_HOME)/sops-nix/secrets;

# API Keys
$env.OPENAI_API_KEY = (open ($SECRETS_PATH)/openai/api_key | str trim)
$env.GEMINI_API_KEY = (open ($SECRETS_PATH)/gemini/api_key | str trim)
$env.CHANNELIO_LINEAR_API_KEY = (open ($SECRETS_PATH)/channelio/linear/api_key | str trim)

# GitHub
$env.GITHUB_TOKEN = (open ($SECRETS_PATH)/github/token | str trim)
$env.GITHUB_PACKAGES_INSTALL_KEY = (open ($SECRETS_PATH)/github/token | str trim)

# Terraform
$env.TF_VAR_aws_jaehong21_access_key = (open ($SECRETS_PATH)/aws/jaehong21/access_key | str trim)
$env.TF_VAR_aws_jaehong21_secret_key = (open ($SECRETS_PATH)/aws/jaehong21/secret_key | str trim)
$env.TF_VAR_aws_trax_access_key = (open ($SECRETS_PATH)/aws/trax/access_key | str trim)
$env.TF_VAR_aws_trax_secret_key = (open ($SECRETS_PATH)/aws/trax/secret_key | str trim)
$env.TF_VAR_aws_nari_access_key = (open ($SECRETS_PATH)/aws/nari/access_key | str trim)
$env.TF_VAR_aws_nari_secret_key = (open ($SECRETS_PATH)/aws/nari/secret_key | str trim)
$env.TF_VAR_cloudflare_jaehong21_api_key = (open ($SECRETS_PATH)/cloudflare/jaehong21/api_key | str trim)
$env.TF_VAR_cloudflare_jaehong21_r2_access_key = (open ($SECRETS_PATH)/cloudflare/jaehong21/r2/access_key | str trim)
$env.TF_VAR_cloudflare_jaehong21_r2_secret_key = (open ($SECRETS_PATH)/cloudflare/jaehong21/r2/secret_key | str trim)
$env.TF_VAR_cloudflare_trax_api_key = (open ($SECRETS_PATH)/cloudflare/trax/api_key | str trim)
$env.TF_VAR_oci_jaehong21_user_ocid = (open ($SECRETS_PATH)/oci/jaehong21/user_ocid | str trim)
$env.TF_VAR_oci_jaehong21_fingerprint = (open ($SECRETS_PATH)/oci/jaehong21/fingerprint | str trim)
$env.TF_VAR_oci_jaehong21_private_key_path = ($SECRETS_PATH)/oci/jaehong21/private_key
$env.TF_VAR_oci_bkw377_user_ocid = (open ($SECRETS_PATH)/oci/bkw377/user_ocid | str trim)
$env.TF_VAR_oci_bkw377_fingerprint = (open ($SECRETS_PATH)/oci/bkw377/fingerprint | str trim)
$env.TF_VAR_oci_bkw377_private_key_path =  ($SECRETS_PATH)/oci/bkw377/private_key
$env.TF_VAR_oci_csia10kmla23_user_ocid = (open ($SECRETS_PATH)/oci/csia10kmla23/user_ocid | str trim)
$env.TF_VAR_oci_csia10kmla23_fingerprint = (open ($SECRETS_PATH)/oci/csia10kmla23/fingerprint | str trim)
$env.TF_VAR_oci_csia10kmla23_private_key_path = ($SECRETS_PATH)/oci/csia10kmla23/private_key
$env.TF_VAR_postgresql_oracle1_password = (open ($SECRETS_PATH)/postgres/oracle1/password | str trim)
$env.TF_VAR_postgresql_nas_password = (open ($SECRETS_PATH)/postgres/nas/password | str trim)
$env.TF_VAR_postgresql_berry1_password = (open ($SECRETS_PATH)/postgres/berry1/password | str trim)
