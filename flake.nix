{
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    nixvim.url = "github:herrluisi/nixvim-config";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs-stable,
      nixpkgs,
      sops-nix,
      disko,
      nixos-facter-modules,
      home-manager,
      nix-index-database,
      nixvim,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      mkPkgs =
        {
          system,
          repo ? nixpkgs,
        }:
        import repo {
          inherit system;
          config.allowUnfree = true;
          config.android_sdk.accept_license = true;
          overlays = [
            (
              _final: prev:
              import ./pkgs {
                inherit inputs;
                pkgs = prev;
              }
            )
          ];
        };
    in
    {
      nixosConfigurations.uisl = lib.nixosSystem rec {
        inherit system;
        pkgs = mkPkgs { inherit system; };
        specialArgs = inputs // {
          pkgs-stable = mkPkgs {
            inherit system;
            repo = nixpkgs-stable;
          };
          libF = import ./lib/default.nix;
          inherit inputs;
        };
        modules = [
          ./hosts/uisl/configuration.nix
          ./modules/base.nix
          
          sops-nix.nixosModules.sops
          nixos-facter-modules.nixosModules.facter
          {
            networking = {
              hostName = "uisl";
              domain = "localhost.localdomain";
            };
          }

          # install comma (,) to run packages without installing them
          nix-index-database.nixosModules.nix-index
          { programs.nix-index-database.comma.enable = true; }

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.uisl = import ./home.nix;
              extraSpecialArgs = inputs // {
                pkgs-stable = mkPkgs {
                  inherit system;
                  repo = nixpkgs-stable;
                };
              };
            };
          }
        ];
      };

      homeConfigurations."uisl" = home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs { inherit system; };
        extraSpecialArgs = inputs // {
          pkgs-stable = mkPkgs {
            inherit system;
            repo = nixpkgs-stable;
          };
        };

        modules = [
          ./home.nix
        ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      
    };
}
