{
  self,
  inputs,
  config,
  pkgs,
  ...
}:

let
  k3sOverlay = final: prev: {
    k3s =
      (import (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "45ebaee5d90bab997812235564af4cf5107bde89";
        hash = "sha256-b8mTUdmB80tHcvvVD+Gf+X2HMMxHGiD/UmOr5nYDAmY=";
      }) { inherit (pkgs) system; }).k3s;
  };
  dockerOverlay = final: prev: {
    docker_28_5_1 =
      (import (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "de69d2ba6c70e747320df9c096523b623d3a4c35";
        hash = "sha256-2qsow3cQIgZB2g8Cy8cW+L9eXDHP6a1PsvOschk5y+E=";
      }) { inherit (pkgs) system; }).docker;
  };
  caddyOverlay = final: prev: {
    caddy_2_10_0 =
      (import (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "648f70160c03151bc2121d179291337ad6bc564b";
        hash = "sha256-FK8iq76wlacriq3u0kFCehsRYTAqjA9nfprpiSWRWIc=";
      }) { inherit (pkgs) system; }).caddy;
  };
in
{
  nixpkgs.overlays = [
    k3sOverlay
    dockerOverlay
    caddyOverlay
  ];

  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    inputs.sops-nix.nixosModules.sops
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    initrd.systemd.enable = true;
  };

  systemd.targets.multi-user.enable = true;

  networking.hostName = "core1";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Seoul";
  i18n.defaultLocale = "en_US.UTF-8";

  # sops-nix for secrets
  # for NixOS, it used to store at `/run/secrets`
  sops = {
    # self.outPath is the flake absolute path
    defaultSopsFile = "${self.outPath}/secrets/encrypted.yaml";
    defaultSopsFormat = "yaml";
    # should have no passphrase
    # NOTE: add `key.txt` manually
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets = {
      # "k3s/token_2" = { };
      "cloudflare/api_token" = { };
      "restic/password" = { };
      "restic/r2/repository" = { };
      "restic/r2/env" = { };
      "postgres/core1/env" = { };
      "pocket_id/core1/env" = { };
    };
  };

  users = {
    mutableUsers = false;
    users.jaehong21 = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [ (builtins.readFile ./id_rsa.pub) ];
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];

      packages = with pkgs; [
        awscli2
        croc
        nh
        python313
        sqlite
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = "jaehong21";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    curl
    dnsutils
    git
    htop
    nfs-utils
    vim
    wget
  ];

  # Enable vnstat
  services.vnstat.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.caddy = {
    enable = true;
    environmentFile = "${config.sops.secrets."cloudflare/api_token".path}";
    package = pkgs.caddy_2_10_0.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
      hash = "sha256-GkmhBeHiuwdpRUDBPG9TRHqLvGnsxltPZMQ9CcRcdGA=";
    };
    # https://caddy.community/t/how-to-use-dns-provider-modules-in-caddy-2/8148
    globalConfig = ''
      acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    '';
    # https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/services/web-servers/caddy/default.nix
    # cert is stored at `/var/lib/caddy/.local/share/caddy/certificates/acme-...`
    virtualHosts = {
      "headscale.jaehong21.com".extraConfig = ''
        reverse_proxy localhost:8080
      '';
      "id.jaehong21.com".extraConfig = ''
        reverse_proxy localhost:1411
      '';
      # "uptime.jaehong21.com".extraConfig = ''
      #   reverse_proxy localhost:3001
      # '';
    };
  };

  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 8080;
    # https://github.com/juanfont/headscale/blob/main/config-example.yaml
    settings = {
      server_url = "https://headscale.jaehong21.com";
      prefixes = {
        allocation = "random"; # default: "sequential"
      };
      dns = {
        magic_dns = true;
        base_domain = "ts.net"; # <hostname>.ts.net
        extra_records = [
          {
            name = "nas.ts.net";
            type = "A";
            value = "192.168.0.9";
          }
        ];
      };
      database = {
        type = "sqlite"; # default
        # sqlite.path = "/var/lib/headscale/db.sqlite";
      };
    };
  };

  # Tailscale VPN
  services.tailscale = {
    enable = true;
  };

  # docker
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_28_5_1;
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      postgres = {
        image = "public.ecr.aws/docker/library/postgres:18.0";
        ports = [ "5432:5432" ];
        environment = {
          TZ = "Asia/Seoul";
          PGDATA = "/var/lib/postgresql/data";
          # POSTGRES_USER = "xxx";
          # POSTGRES_PASSWORD = "xxx";
          # POSTGRES_DB = "xxx";
        };
        environmentFiles = [ "${config.sops.secrets."postgres/core1/env".path}" ];
        volumes = [
          "/var/lib/postgresql/18:/var/lib/postgresql/data"
        ];
      };
      pocket-id = {
        image = "ghcr.io/pocket-id/pocket-id:v1.15.0";
        ports = [ "1411:1411" ];
        environment = {
          APP_URL = "https://id.jaehong21.com";
          TRUST_PROXY = "true";
          ANALYTICS_DISABLED = "true";
          # ENCRYPTION_KEY = "xxx";
          # default
          # PORT = "1411";
          # DB_PROVIDER = "sqlite";
          # KEYS_STORAGE = "file";
        };
        environmentFiles = [ "${config.sops.secrets."pocket_id/core1/env".path}" ];
        volumes = [
          "/var/lib/pocket-id:/app/data"
        ];
      };
      greptime = {
        image = "greptime/greptimedb:v1.0.0-beta.1";
        ports = [ "4000-4003:4000-4003" ];
        cmd = [
          "standalone"
          "start"
        ];
        environment = {
          # https://docs.greptime.com/user-guide/deployments-administration/configuration/
          # https://github.com/GreptimeTeam/greptimedb/blob/v1.0.0-beta.1/config/standalone.example.toml
          GREPTIMEDB_STANDALONE__HTTP__ADDR = "0.0.0.0:4000";
          GREPTIMEDB_STANDALONE__GRPC__BIND_ADDR = "0.0.0.0:4001";
          GREPTIMEDB_STANDALONE__MYSQL__ENABLE = "false";
          GREPTIMEDB_STANDALONE__POSTGRES__ADDR = "0.0.0.0:4003";
          # default
          # GREPTIMEDB_STANDALONE__STORAGE__DATA_HOME = "./greptimedb_data";
          # GREPTIMEDB_STANDALONE__STORAGE__TYPE = "File";
        };
        volumes = [
          "/var/lib/greptime:/greptimedb_data"
        ];
      };
    };
  };

  # k3s server
  services.k3s = {
    enable = true;
    role = "server";
    # tokenFile = "${config.sops.secrets."k3s/token_2".path}"; # only enable for etcd cluster
    serverAddr = "https://k3s.jaehong21.com:6443";
    clusterInit = false; # use sqlite instead of etcd for now
    extraFlags = [
      "--tls-san k3s.jaehong21.com"
      "--flannel-iface tailscale0"
      "--disable servicelb,traefik,local-storage,metrics-server"
    ];
  };

  # restic backup
  services.restic = {
    backups = {
      # use `sudo restic-r2backup snapshots` to check
      r2backup = {
        initialize = true;
        passwordFile = config.sops.secrets."restic/password".path;

        # cloudflare R2
        repositoryFile = config.sops.secrets."restic/r2/repository".path;
        # 1) AWS_ACCESS_KEY_ID, 2) AWS_SECRET_ACCESS_KEY, 3) HC_URL should be set
        environmentFile = config.sops.secrets."restic/r2/env".path;
        extraOptions = [
          "s3.region=apac"
          "s3.bucket-lookup=path"
        ];
        paths = [
          "/var/lib/headscale"
          "/var/lib/caddy"
          "/var/lib/rancher/k3s/server/db"
          "/var/lib/pocket-id"
        ];
        timerConfig = {
          OnCalendar = "03:00"; # every day at 3am
          Persistent = true;
          RandomizedDelaySec = "10m"; # random delay up to 10 minutes
        };
        pruneOpts = [
          "--keep-daily=7"
          "--keep-monthly=12"
        ];
        # send ping to healthchecks.io
        backupCleanupCommand = "${pkgs.curl}/bin/curl -fsS -m 10 --retry 5 -o /dev/null $HC_URL";
      };
    };
  };

  # Open ports in the firewall.
  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [
      22 # ssh
      80 # http
      443 # https
      4000 # greptime http
      4001 # greptime grpc
      4003 # greptime postgres
      6443 # k3s api server
      10250 # kubelet metrics
    ];
    allowedUDPPorts = [
      config.services.tailscale.port # 41641
      8472 # flannel (vxlan)
    ];
  };
  # networking.firewall.enable = false;

  # Disable documentation for minimal install.
  documentation.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
