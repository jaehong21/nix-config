{ self, inputs, config, lib, pkgs, ... }:

let
  k3sOverlay = final: prev: {
    k3s = (import
      (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "199169a2135e6b864a888e89a2ace345703c025d";
        hash = "sha256-igS2Z4tVw5W/x3lCZeeadt0vcU9fxtetZ/RyrqsCRQ0=";
      })
      { inherit (pkgs) system; }).k3s;
  };
  dockerOverlay = final: prev: {
    docker_27_5_1 = (import
      (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "642c54c23609fefb5708b0e2be261446c59138f6";
        hash = "sha256-4Y0ByuP4NEz2Zyso9Ozob8yR6kKuaunJ5OARv+tFLPI=";
      })
      { inherit (pkgs) system; }).docker;
  };
  # tailscaleOverlay = final: prev: {
  #   tailscale_1_78_1 = (import
  #     (pkgs.fetchFromGitHub {
  #       owner = "NixOS";
  #       repo = "nixpkgs";
  #       rev = "d98abf5cf5914e5e4e9d57205e3af55ca90ffc1d";
  #       hash = "sha256-oZLdIlpBKY+WEJlKMafIUK+MBqddHreSeGc4b4yF1uU=";
  #     })
  #     { inherit (pkgs) system; }).tailscale;
  # };
in
{
  nixpkgs.overlays = [
    k3sOverlay
    dockerOverlay
    # tailscaleOverlay
  ];

  imports =
    [
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

  networking.hostName = "oracle3";
  networking.networkmanager.enable = true;

  # Explicitly enable dbus for NixOS 25.05 compatibility
  services.dbus.enable = true;

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
    };
  };

  users = {
    mutableUsers = false;
    users.jaehong21 = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [ (builtins.readFile ./id_rsa.pub) ];
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
      ];

      packages = with pkgs; [
        fastfetch
        gh
        gnupg
        nh
        python310
        tailscale # CLI
        tree
        xh
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = "jaehong21";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 5";
    clean.dates = "daily"; # default: weekly
    flake = "/home/jaehong21/.config/nix-config";
  };

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
    # package = pkgs.tailscale_1_78_1;
    enable = true;
    extraSetFlags = [ "--accept-routes" ];
    # default values
    # useRoutingFeatures = "server";
    # port = 41641;
    # interfaceName = "tailscale0";
  };

  # use docker
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_27_5_1;
  virtualisation.oci-containers = {
    backend = "docker";
    containers = { };
  };

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
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 6443 10250 ];
    allowedUDPPorts = [ 8472 config.services.tailscale.port ];

    # extraCommands =
    #   let
    #     # These rules are inserted at position 1. Each new rule pushes previous ones down.
    #     mkPrioAcceptRule = proto: port: ''
    #       iptables -I INPUT 1 -p ${proto} --dport ${toString port} -j ACCEPT -m comment --comment "High priority accept for NixOS defined ${proto} port ${toString port}"
    #     '';
    #
    #     tcpPrioRules = map (mkPrioAcceptRule "tcp") config.networking.firewall.allowedTCPPorts;
    #     udpPrioRules = map (mkPrioAcceptRule "udp") config.networking.firewall.allowedUDPPorts;
    #   in
    #   # Concatenate all generated rule strings, separated by newlines
    #   builtins.concatStringsSep "\n" (tcpPrioRules ++ udpPrioRules);
  };

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
