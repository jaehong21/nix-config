{ self, inputs, config, pkgs, lib, ... }:

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
in
{
  nixpkgs.overlays = [
    k3sOverlay
    dockerOverlay
  ];

  imports =
    [
      ./hardware-configuration.nix
      inputs.sops-nix.nixosModules.sops
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.systemd.enable = true;

  networking.hostName = "desk1"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jaehong21 = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [ (builtins.readFile ./id_rsa.pub) ];
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
      "docker"
    ];

    packages = with pkgs; [
      fastfetch
      gh
      gnupg
      nh
      uv
      python312
      go_1_24
      tailscale # CLI
      tree
    ];
  };

  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = "jaehong21";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };

  environment.systemPackages = with pkgs; [
    curl
    dnsutils
    git
    htop
    nfs-utils
    nvtopPackages.nvidia
    vim
    wget

    # NVIDIA container runtime tools
    # nvidia-container-toolkit
    # libnvidia-container
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
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_27_5_1;
  };
  hardware.nvidia-container-toolkit.enable = true; # need to run with CDI (e.g. `--device=nvidia.com/gpu=all`)
  virtualisation.oci-containers = {
    backend = "docker";
  };

  # nvidia
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  services.xserver.videoDrivers = [
    "nvidia"
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # k3s agent
  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = "${config.sops.secrets."k3s/token".path}";
    serverAddr = "https://kube.jaehong21.com:6443";
    extraFlags = [
      "--flannel-iface tailscale0"
    ];
  };

  # Open ports in the firewall.
  networking.firewall.enable = false;

  # Disable documentation for minimal install.
  documentation.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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
  system.stateVersion = "25.05"; # Did you read the comment?
}

