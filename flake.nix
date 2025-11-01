{
  inputs = {
    nixpkgs-2505.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs-2505,
      nixpkgs,
      sops-nix,
      lanzaboote,
      nixos-facter-modules,
      home-manager,
      nix-index-database,
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
      nixosConfigurations.uisl = lib.nixosSystem {
        inherit system;
        pkgs = mkPkgs { inherit system; };
        specialArgs = inputs // {
          pkgs-2505 = mkPkgs {
            inherit system;
            repo = nixpkgs-2505;
          };
          libF = import ./lib/default.nix { inherit pkgs lib; };
        };
        modules = [
          ./hosts/uisl/configuration.nix
          ./modules/base.nix

          lanzaboote.nixosModules.lanzaboote
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
            };
          }
          ./modules/nvidia.nix
        ];
      };

      homeConfigurations."uisl" = home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs { inherit system; };
        extraSpecialArgs = inputs // {
          pkgs-2505 = mkPkgs {
            inherit system;
            repo = nixpkgs-2505;
          };
        };

        modules = [
          ./home.nix
        ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
