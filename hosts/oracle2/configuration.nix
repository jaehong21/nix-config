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

  networking.hostName = "oracle2";
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
      "k3s/token_2" = { };
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
        chisel
        nh
        python313
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = null;

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
      chisel-server = {
        image = "jpillora/chisel:1.11.3";
        ports = [ "9090:9090" ];
        networks = [ "host" ];
        # NOTE: `/var/lib/chisel/chisel.key` and `/var/lib/chisel/users.json` should be created manually

        cmd = [
          "server"
          "--port"
          "9090"
          "--keyfile"
          "/var/lib/chisel/chisel.key" # `chisel server --keygen /var/lib/chisel/chisel.key`
          "--authfile"
          "/var/lib/chisel/users.json"
        ];
        volumes = [
          "/var/lib/chisel:/var/lib/chisel:ro"
        ];
      };
    };
  };

  services.pgbouncer = {
    enable = true;
    openFirewall = true; # 6432
    settings = {
      pgbouncer = {
        listen_addr = "*";
        listen_port = 6432; # default
        # https://www.pgbouncer.org/config.html#authentication-settings
        auth_type = "trust";
      };
      databases = {
        trax_mento_dev = "host=core1 dbname=trax_mento_dev";
      };
    };
  };

  # haproxy
  services.haproxy = {
    enable = true;
    config = builtins.readFile ./haproxy.cfg;
  };

  # k3s agent
  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = "${config.sops.secrets."k3s/token_2".path}";
    serverAddr = "https://k3s.jaehong21.com:6443";
    extraFlags = [
      "--flannel-iface tailscale0"
    ];
  };

  # Open ports in the firewall.
  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [
      22 # ssh
      80 # http
      443 # https
      9090 # chisel server
      # 6432 # pgbouncer
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
