{ self, inputs, config, lib, pkgs, ... }:

let
  k3sOverlay = final: prev: {
    k3s = (import
      (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "ef56e777fedaa4da8c66a150081523c5de1e0171";
        hash = "sha256-a3MMEY7i/wdF0gb7WFNTn6onzaiMOvwj7OerRVenA8o=";
      })
      { inherit (pkgs) system; }).k3s;
  };
in
{
  nixpkgs.overlays = [
    k3sOverlay
  ];

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.sops-nix.nixosModules.sops
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;

  # for Rpi 5
  boot.loader.efi.canTouchEfiVariables = false;
  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  # https://github.com/k3s-io/k3s/issues/2067#issuecomment-801710748
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/CLUSTER_UPKEEP.md#raspberry-pi-not-working
  # for k3s service in Raspberry Pi
  boot.kernelParams = [
    "cgroup_enable=cpuset"
    "cgroup_memory=1"
    "cgroup_enable=memory"
  ];

  # disable swap
  swapDevices = lib.mkForce [ ];

  networking.hostName = "berry3"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Seoul";
  i18n.defaultLocale = "en_US.UTF-8";

  # sops-nix for secrets
  # for NixOS, it used to store at `/run/secrets`
  sops = {
    # self.outPath is the flake absolute path
    defaultSopsFile = "${self.outPath}/secrets/encrypted.yaml";
    defaultSopsFormat = "yaml";
    # should have no passphrase
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets = {
      "k3s/token" = { };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false; # disable change password with `passwd`.
  users.users.root.hashedPassword = "!";
  users.users.jaehong21 = {
    isNormalUser = true;
    # initialPassword = "xxx";
    hashedPassword = "!";
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
      htop
      nh
      python310
      tailscale # CLI
      tree
    ];
  };

  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = "jaehong21";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    dnsutils
    git
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  # List services that you want to enable:

  # Google's NTP service instead systemd-timesyncd
  services.ntp = {
    enable = true; # it disables systemd.timesyncd
    servers = [ "time.google.com" ];
    extraFlags = [ "-b" ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PermitRootLogin = "no";
      # disable for public key authentication
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Tailscale VPN
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  # use docker
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers = { };
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
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

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
  system.stateVersion = "24.11"; # Did you read the comment?
}
