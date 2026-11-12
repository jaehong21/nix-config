{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Seed a new installation only. Keep later Control UI/onboarding changes in
  # the persistent state directory rather than making openclaw.json read-only.
  initialConfig = pkgs.writeText "openclaw-initial.json" (
    builtins.toJSON {
      gateway = {
        mode = "local";
        bind = "lan";
        port = 18789;
        publicOrigin = "https://openclaw.jaehong21.com";
        auth = {
          mode = "token";
          allowTailscale = false;
        };
        tailscale.mode = "off";
        trustedProxies = [ "172.17.0.1" ];
        controlUi.allowedOrigins = [ "https://openclaw.jaehong21.com" ];
      };
    }
  );
in
{
  sops.secrets."openclaw/core1/env" = {
    restartUnits = [ "docker-openclaw.service" ];
  };

  # The official image runs as node (UID/GID 1000). The parent is root-only;
  # Docker bind-mounts the writable children directly into the container.
  systemd.tmpfiles.rules = [
    "d /var/lib/openclaw 0700 root root -"
    "d /var/lib/openclaw/state 0700 1000 1000 -"
    "d /var/lib/openclaw/workspace 0700 1000 1000 -"
    "d /var/lib/openclaw/auth-profile-secrets 0700 1000 1000 -"
    "d /var/lib/openclaw/update-captures 0700 1000 1000 -"
  ];

  systemd.services.docker-openclaw.preStart = lib.mkBefore ''
    if [ ! -e /var/lib/openclaw/state/openclaw.json ]; then
      ${pkgs.coreutils}/bin/install -m 0600 -o 1000 -g 1000 \
        ${initialConfig} /var/lib/openclaw/state/openclaw.json
    fi
  '';

  virtualisation.oci-containers.containers.openclaw = {
    image = "ghcr.io/openclaw/openclaw:2026.11.3@sha256:e73f689d663567f0fe3c5a85c54beb3e102dc21f0814bf375e9039ee2d2df51b";
    autoStart = true;
    ports = [ "127.0.0.1:18789:18789" ];
    environment = {
      HOME = "/home/node";
      OPENCLAW_HOME = "/home/node";
      OPENCLAW_STATE_DIR = "/home/node/.openclaw";
      OPENCLAW_CONFIG_PATH = "/home/node/.openclaw/openclaw.json";
      OPENCLAW_CONFIG_DIR = "/home/node/.openclaw";
      OPENCLAW_WORKSPACE_DIR = "/home/node/.openclaw/workspace";
      OPENCLAW_GATEWAY_PORT = "18789";
      TZ = "Asia/Seoul";
    };
    environmentFiles = [ config.sops.secrets."openclaw/core1/env".path ];
    volumes = [
      "/var/lib/openclaw/state:/home/node/.openclaw"
      "/var/lib/openclaw/workspace:/home/node/.openclaw/workspace"
      "/var/lib/openclaw/auth-profile-secrets:/home/node/.config/openclaw"
      # Doctor captures pre-upgrade state beside OPENCLAW_STATE_DIR.
      "/var/lib/openclaw/update-captures:/home/node/.openclaw.update-captures"
    ];
    extraOptions = [
      "--cap-drop=NET_RAW"
      "--cap-drop=NET_ADMIN"
      "--security-opt=no-new-privileges:true"
      "--health-interval=30s"
      "--health-start-period=60s"
    ];
  };

  services.caddy.virtualHosts."openclaw.jaehong21.com".extraConfig = ''
    reverse_proxy 127.0.0.1:18789
  '';
}
