{
  description = "jaehong21 system flake";

  inputs = {
    # Nix Ecosystem
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # disko
    disko = {
      # "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/v1.11.0.tar.gz"}/module.nix"
      url = "https://github.com/nix-community/disko/archive/v1.11.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secrets
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      ...
    }@inputs:
    {
      homeConfigurations = {
        "jetty" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit self inputs;
            nixConfigDir = "/Users/jetty/.config/nix-config";
          };
          modules = [
            ./home/jetty/configuration.nix
          ];
        };
      };

      # Build nixos flake using:
      # $ sudo nixos-rebuild build --flake .#berry2
      nixosConfigurations = {
        core1 = nixpkgs-stable.lib.nixosSystem {
          system = "aarch64-linux";
          pkgs = import nixpkgs-stable {
            system = "aarch64-linux";
            config.allowUnfree = true;
          };
          specialArgs = { inherit self inputs; };
          modules = [
            ./hosts/core1/configuration.nix
          ];
        };
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
      };
    };
}
