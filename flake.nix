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
    # Homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # disko
    disko = {
      # "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/v1.11.0.tar.gz"}/module.nix"
      url = "https://github.com/nix-community/disko/archive/v1.11.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secrets
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, darwin, home-manager, nix-homebrew, ... }@inputs: {
    homeConfigurations = {
      # Work laptop
      # <username>@<hostname>
      "jetty@jetty-159.local" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit self inputs; }; # pass inputs to home.nix
        modules = [
          ./home/jetty/configuration.nix
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
      oracle1 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        specialArgs = { inherit self inputs; };
        modules = [
          ./hosts/oracle1/configuration.nix
        ];
      };
      oracle2 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        specialArgs = { inherit self inputs; };
        modules = [
          ./hosts/oracle2/configuration.nix
        ];
      };
      oracle3 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        specialArgs = { inherit self inputs; };
        modules = [
          ./hosts/oracle3/configuration.nix
        ];
      };
      berry1 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        specialArgs = { inherit self inputs; };
        modules = [
          ./hosts/berry1/configuration.nix
        ];
      };
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
      berry3 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        specialArgs = { inherit self inputs; };
        modules = [
          ./hosts/berry3/configuration.nix
        ];
      };
    };

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#jetty
    darwinConfigurations = {
      # <hostname>
      "jetty-159" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./darwin/jetty/configuration.nix
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
