{
  description = "jaehong21 system flake";

  inputs = {
    # Nix Ecosystem
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

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
      ...
    }@inputs: {
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
      };
    };
}
