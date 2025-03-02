{ self, inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/v1.11.0.tar.gz"}/module.nix"
      ./disk-config.nix
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

  time.timeZone = "Asia/Seoul";
  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    mutableUsers = false;
    users.jaehong21 = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDV/BTO0yuaMxO6K9jmgRDIYPE1OGnb1EeCA/ywBvEkcUEZ+wO2Hu0mxavHeKwrMvNgPabEzE93jOdIh8CjQ/XpaBuZ1d/aqXZL/MVp4mkWfGxDAsOEeSUg43lFvefTx/APStaUbZFRlTO2pH4EqSrg6QEzgeQx6XfZvFggzqVqUynzntAGINmbD3519ismRIBUdgGgz+QpNP8g4oEPMvv5gEVmnGq+o9tvy3ZphmKfbX9Cpz48XlkbqucfFojO8gFpCrFgzA/ukGkqsJ1T/jLviNHjIzgwLvBT67H0yR2MtPpNSki0gWrZ1iIVd3fa65Iu4EeVsxGR4RxrxC7iRbpt5kmfQnlPzbTvpZWb0IQJlyZaBkt68rnjj2MYuqiZwWMETh7uQYr3oAmShPTQ4lxL2D1DIIy1XuSc15ieGRdRMukSidl+LDQraOmwibdtFEITFrBTbgvT9LQe+7EjTgctrBeGwPuhJqvRbIUpukdeYy8wEl/+7Buqjl22z07no88AolI0+dXNSsTsVLS0XP3TVooBU0hzx8IdDacqFmuxEXfn6wARdAiBx8kc3cja7DE+/ICg7potq4Azc6rMnKf+oh8kLcB0ZyBvU79VYyhDLxaeA9ijuWNF90qq9SPryYcDEx0uu5z2yFORf2rr73k9CxuA8n0+Ox41XCgjLXg8kQ=="
      ];
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        gh
        gnupg
        htop
        python310
        tailscale # CLI
        tree
        fastfetch
        nh
      ];
    };
  };
  security.sudo.wheelNeedsPassword = false;

  services.getty.autologinUser = "jaehong21";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    vim
    vnstat
    wget
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      MaxAuthTries = 20;
    };
  };

  # Tailscale VPN
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = false;

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
