{
  description = "jaehong21 system flake";

  inputs = {
    # Nix Ecosystem
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-vicuna.url = "github:NixOS/nixpkgs/nixos-24.11";
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

  outputs = { self, nixpkgs, nixpkgs-stable, nixpkgs-vicuna, darwin, home-manager, nix-homebrew, ... }@inputs: {
    homeConfigurations = {
      # Work laptop
      # <username>@<hostname>, e.g. "jetty@jetty-213"
      "jetty@jetty" = home-manager.lib.homeManagerConfiguration {
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
      "jaehong21@desk1" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit self inputs; };
        modules = [
          ./home/desk1/configuration.nix
          {
            home.username = "jaehong21";
            home.homeDirectory = "/home/jaehong21";
          }
        ];
      };
    };

    # Build nixos flake using:
    # $ sudo nixos-rebuild build --flake .#berry2
    nixosConfigurations = {
      oracle1 = nixpkgs-stable.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = import nixpkgs-stable {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        specialArgs = { inherit self inputs; };
        modules = [
          ./hosts/oracle1/configuration.nix
        ];
      };
      oracle2 = nixpkgs-stable.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = import nixpkgs-stable {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        specialArgs = { inherit self inputs; };
        modules = [
          ./hosts/oracle2/configuration.nix
        ];
      };
      oracle3 = nixpkgs-stable.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = import nixpkgs-stable {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        specialArgs = { inherit self inputs; };
        modules = [
          ./hosts/oracle3/configuration.nix
        ];
      };
      desk1 = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = import nixpkgs-stable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        specialArgs = { inherit self inputs; };
        modules = [
          ./hosts/desk1/configuration.nix
        ];
      };
      berry1 = nixpkgs-vicuna.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = import nixpkgs-vicuna {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        specialArgs = { inherit self inputs; };
        modules = [
          ./hosts/berry1/configuration.nix
        ];
      };
      berry2 = nixpkgs-vicuna.lib.nixosSystem {
        system = "aarch64-linux";
        pkgs = import nixpkgs-vicuna {
          system = "aarch64-linux";
          config.allowUnfree = true;
        };
        specialArgs = { inherit self inputs; };
        modules = [
          ./hosts/berry2/configuration.nix
        ];
      };
      # berry3 = nixpkgs-vicuna.lib.nixosSystem {
      #   system = "aarch64-linux";
      #   pkgs = import nixpkgs-vicuna {
      #     system = "aarch64-linux";
      #     config.allowUnfree = true;
      #   };
      #   specialArgs = { inherit self inputs; };
      #   modules = [
      #     ./hosts/berry3/configuration.nix
      #   ];
      # };
    };

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#jetty
    darwinConfigurations = {
      # <hostname>
      "jetty" = darwin.lib.darwinSystem {
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
