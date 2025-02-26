{
  description = "jaehong21 system flake";

  inputs = {
    # Nix Ecosystem
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
      ...
    }@inputs:
    {
      homeConfigurations = {
        # <username>@<hostname>
        # Work laptop
        "jetty@jetty.local" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit inputs self; }; # pass inputs to home.nix
          modules = [
            ./hosts/jetty/home.nix
            {
              home.username = "jetty";
              home.homeDirectory = "/Users/jetty";
            }
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
            ./darwin
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
