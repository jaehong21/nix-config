{ self, inputs, config, pkgs, ... }:

{
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
    ];

    packages = with pkgs; [
      fastfetch
      gh
      gnupg
      nh
      python310
      tailscale # CLI
      tree
    ];
  };

  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = "jaehong21";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
  # virtualisation.docker.enable = true;

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

