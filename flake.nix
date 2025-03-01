{
  description = "jaehong21 system flake";

  inputs = {
    # Nix Ecosystem
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Nix Darwin
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs: {
    homeConfigurations = {
      # Work laptop
      # <username>
      "jetty" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit self inputs; }; # pass inputs to home.nix
        modules = [
          ./hosts/jetty/home.nix
          {
            home.username = "jetty";
            home.homeDirectory = "/Users/jetty";
          }
        ];
      };
    };

    # Build nixos flake using:
    # $ sudo nixos-rebuild build --flake .#berry2
    nixosConfigurations = {
      berry2 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        specialArgs = { inherit self inputs; };
        modules = [
          ./hosts/berry2/configuration.nix
        ];
      };
    };

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#jetty
    darwinConfigurations = {
      # <hostname>
      jetty = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin/jetty
          {
            nixpkgs.hostPlatform = "aarch64-darwin";
            users.users.jetty = {
              name = "jetty";
              home = "/Users/jetty";
            };
          }
        ];
      };
    };
  };
}
