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
        rev = "f4b140d5b253f5e2a1ff4e5506edbf8267724bde";
        hash = "sha256-rqoqF0LEi+6ZT59tr+hTQlxVwrzQsET01U4uUdmqRtM=";
      }) { inherit (pkgs) system; }).k3s;
  };
  dockerOverlay = final: prev: {
    docker_27_5_1 =
      (import (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "642c54c23609fefb5708b0e2be261446c59138f6";
        hash = "sha256-4Y0ByuP4NEz2Zyso9Ozob8yR6kKuaunJ5OARv+tFLPI=";
      }) { inherit (pkgs) system; }).docker;
  };
in
{
  nixpkgs.overlays = [
    k3sOverlay
    dockerOverlay
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

  networking.hostName = "oracle1";
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
      "k3s/token" = { };
      # "postgres/oracle1/env_file" = { };
      # "redis/oracle1/password" = { };
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
        dust
        fastfetch
        gh
        gnupg
        nh
        python310
        tailscale # CLI
        tree
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

  # Google's NTP service instead systemd-timesyncd
  services.ntp = {
    enable = true; # it disables systemd.timesyncd
    servers = [ "time.google.com" ];
    extraFlags = [ "-b" ];
  };

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

  # Tailscale VPN
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  # use docker
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_27_5_1;
  virtualisation.oci-containers = {
    backend = "docker";
    containers = { };
    # containers = {
    #   postgres = {
    #     image = "public.ecr.aws/docker/library/postgres:17.4";
    #     ports = [ "5432:5432" ];
    #     environment = {
    #       TZ = "Asia/Seoul";
    #       PGDATA = "/var/lib/postgresql/data";
    #       # POSTGRES_USER = "xxx";
    #       # POSTGRES_PASSWORD = "xxx";
    #       # POSTGRES_DB = "xxx";
    #     };
    #     environmentFiles = [ "${config.sops.secrets."postgres/oracle1/env_file".path}" ];
    #     volumes = [
    #       "/var/lib/postgresql/17:/var/lib/postgresql/data"
    #     ];
    #   };
    # };
  };

  # services.redis = {
  #   # sudo systemctl status redis-${redisName}
  #   servers = {
  #     # redisConfVar = "/var/lib/redis-${redisName}/redis.conf";
  #     # redisDataDir = "/var/lib/redis-${redisName}/dump.rdb";
  #     # redisName: oracle1
  #     oracle1 = {
  #       enable = true;
  #       bind = "0.0.0.0";
  #       port = 6379;
  #       save = [ [ 900 1 ] [ 300 10 ] [ 60 10000 ] ];
  #       appendOnly = false;
  #       requirePassFile = "${config.sops.secrets."redis/oracle1/password".path}";
  #     };
  #   };
  # };

  # haproxy
  services.haproxy = {
    enable = true;
    config = builtins.readFile ./haproxy.cfg;
    user = "haproxy";
    group = "haproxy";
  };

  # k3s server
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = "${config.sops.secrets."k3s/token".path}";
    serverAddr = "https://kube.jaehong21.com:6443";
    clusterInit = true;
    extraFlags = [
      "--write-kubeconfig-mode 644"
      "--tls-san kube.jaehong21.com"
      "--cluster-cidr 10.42.0.0/16"
      "--service-cidr 10.43.0.0/16"
      "--cluster-dns 10.43.0.10"
      "--flannel-iface tailscale0"
      "--flannel-backend vxlan" # default
      "--disable servicelb,traefik,local-storage,metrics-server"
    ];
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22 # ssh
    80 # http
    443 # https
    # 5432 # postgres
    # 6379 # redis
    6443 # k3s api server
    10250 # k3s metrics
  ];
  networking.firewall.allowedUDPPorts = [
    8472 # flannel
  ];
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
