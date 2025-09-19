{ ... }:

{
  sops.secrets = {
    "openai/api_key" = { };
    "gemini/api_key" = { };
    "github/token" = { };

    "channelio/aws/ch_dev/account_id" = { };
    "channelio/aws/ch_prod/account_id" = { };
    "channelio/linear/api_key" = { };

    "aws/jaehong21/access_key" = { };
    "aws/jaehong21/secret_key" = { };
    "aws/trax/access_key" = { };
    "aws/trax/secret_key" = { };
    "aws/nari/account_id" = { };
    "aws/nari/access_key" = { };
    "aws/nari/secret_key" = { };

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
  };
}

