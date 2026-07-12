{ config, ... }:

{
  sops.secrets = {
    "github/token" = { };

    "openrouter/api_key" = { };
    "minimax/api_key" = { };
    "groq/api_key" = { };
    "prism/codex/api_key" = { };

    "linear/api_key" = { };
    "grafana/account_token" = { };
  };

  home.sessionVariables = {
    GITHUB_TOKEN = "$(cat ${config.sops.secrets."github/token".path})";
    GITHUB_PACKAGES_INSTALL_KEY = "$(cat ${config.sops.secrets."github/token".path})";
    OPENROUTER_API_KEY = "$(cat ${config.sops.secrets."openrouter/api_key".path})";
    MINIMAX_API_KEY = "$(cat ${config.sops.secrets."minimax/api_key".path})";
    GROQ_API_KEY = "$(cat ${config.sops.secrets."groq/api_key".path})";
    PRISM_CODEX_API_KEY = "$(cat ${config.sops.secrets."prism/codex/api_key".path})";
    LINEAR_API_KEY = "$(cat ${config.sops.secrets."linear/api_key".path})";
    GRAFANA_SERVICE_ACCOUNT_TOKEN = "$(cat ${config.sops.secrets."grafana/account_token".path})";
  };
}
