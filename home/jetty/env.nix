{ config, ... }:

{
  # Environment variables configuration
  home.sessionVariables = {
    XDG_CONFIG_HOME = "${config.xdg.configHome}";

    AWS_PROFILE = "default";
    OPENAI_API_KEY = "$(cat ${config.sops.secrets."openai/api_key".path})";
    # GOOGLE_CLOUD_PROJECT = "jaehong21"; # used in `gemini-cli`

    CHANNELIO_LINEAR_API_KEY = "$(cat ${config.sops.secrets."channelio/linear/api_key".path})";

    TF_VAR_aws_jaehong21_access_key = "$(cat ${config.sops.secrets."aws/jaehong21/access_key".path})";
    TF_VAR_aws_jaehong21_secret_key = "$(cat ${config.sops.secrets."aws/jaehong21/secret_key".path})";
    TF_VAR_aws_trax_access_key = "$(cat ${config.sops.secrets."aws/trax/access_key".path})";
    TF_VAR_aws_trax_secret_key = "$(cat ${config.sops.secrets."aws/trax/secret_key".path})";
    TF_VAR_aws_nari_access_key = "$(cat ${config.sops.secrets."aws/nari/access_key".path})";
    TF_VAR_aws_nari_secret_key = "$(cat ${config.sops.secrets."aws/nari/secret_key".path})";
    TF_VAR_cloudflare_jaehong21_api_key = "$(cat ${config.sops.secrets."cloudflare/jaehong21/api_key".path})";
    TF_VAR_cloudflare_jaehong21_r2_access_key = "$(cat ${config.sops.secrets."cloudflare/jaehong21/r2/access_key".path})";
    TF_VAR_cloudflare_jaehong21_r2_secret_key = "$(cat ${config.sops.secrets."cloudflare/jaehong21/r2/secret_key".path})";
    TF_VAR_cloudflare_trax_api_key = "$(cat ${config.sops.secrets."cloudflare/trax/api_key".path})";
    TF_VAR_oci_jaehong21_user_ocid = "$(cat ${config.sops.secrets."oci/jaehong21/user_ocid".path})";
    TF_VAR_oci_jaehong21_fingerprint = "$(cat ${config.sops.secrets."oci/jaehong21/fingerprint".path})";
    TF_VAR_oci_jaehong21_private_key_path = "${config.sops.secrets."oci/jaehong21/private_key".path}";
    TF_VAR_oci_bkw377_user_ocid = "$(cat ${config.sops.secrets."oci/bkw377/user_ocid".path})";
    TF_VAR_oci_bkw377_fingerprint = "$(cat ${config.sops.secrets."oci/bkw377/fingerprint".path})";
    TF_VAR_oci_bkw377_private_key_path = "${config.sops.secrets."oci/bkw377/private_key".path}";
    TF_VAR_oci_csia10kmla23_user_ocid = "$(cat ${config.sops.secrets."oci/csia10kmla23/user_ocid".path})";
    TF_VAR_oci_csia10kmla23_fingerprint = "$(cat ${config.sops.secrets."oci/csia10kmla23/fingerprint".path})";
    TF_VAR_oci_csia10kmla23_private_key_path = "${config.sops.secrets."oci/csia10kmla23/private_key".path}";
    TF_VAR_postgresql_oracle1_password = "$(cat ${config.sops.secrets."postgres/oracle1/password".path})";
    TF_VAR_postgresql_nas_password = "$(cat ${config.sops.secrets."postgres/nas/password".path})";
    TF_VAR_postgresql_berry1_password = "$(cat ${config.sops.secrets."postgres/berry1/password".path})";
  };

  sops.secrets = {
    "openai/api_key" = { };
    "gemini/api_key" = { };
    "aws/jaehong21/access_key" = { };
    "aws/jaehong21/secret_key" = { };
    "aws/trax/access_key" = { };
    "aws/trax/secret_key" = { };
    "aws/nari/access_key" = { };
    "aws/nari/secret_key" = { };
    "channelio/linear/api_key" = { };
    "cloudflare/jaehong21/api_key" = { };
    "cloudflare/jaehong21/r2/access_key" = { };
    "cloudflare/jaehong21/r2/secret_key" = { };
    "cloudflare/trax/api_key" = { };
    "oci/jaehong21/user_ocid" = { };
    "oci/jaehong21/fingerprint" = { };
    "oci/jaehong21/private_key" = { };
    "oci/bkw377/user_ocid" = { };
    "oci/bkw377/fingerprint" = { };
    "oci/bkw377/private_key" = { };
    "oci/csia10kmla23/user_ocid" = { };
    "oci/csia10kmla23/fingerprint" = { };
    "oci/csia10kmla23/private_key" = { };
    "postgres/oracle1/password" = { };
    "postgres/nas/password" = { };
    "postgres/berry1/password" = { };
  };
}

