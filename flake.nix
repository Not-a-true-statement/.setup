{
  description = "A very basic flake";
  
  outputs = inputs @ { self, nixpkgs, home-manager, flake-utils, ...}:
  let
    # User
    user = "tar";
    location = "$HOME/.setup";

    # Nix
    stateVersion = "24.11";

    # Importing for system and home manager
    importSystem = modules: map (import: import.system) modules;
    importHome = modules: map (import: import.home) modules;
  in
  {
    nixosConfigurations = {

      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit importSystem inputs stateVersion user location nixpkgs flake-utils;
        };
        modules = [
          (import ./hosts/common).system
          (import ./hosts/desktop).system

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              inherit importHome inputs stateVersion user location;
              configName = "desktop";
            };
            home-manager.users.${user} = {
              imports = [
                (import ./hosts/common).home
                (import ./hosts/desktop).home
              ];
            };
          }
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit importSystem inputs stateVersion user location nixpkgs flake-utils;
        };
        modules = [
          (import ./hosts/common).system
          (import ./hosts/laptop).system

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              inherit importHome inputs stateVersion user location;
              configName = "laptop";
            };
            home-manager.users.${user} = {
              imports = [
                (import ./hosts/common).home
                (import ./hosts/laptop).home
              ];
            };
          }
        ];
      };

    };
  };



  inputs = {

    # Nix packages
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    # Nix flake utilities
    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    # https://github.com/nix-community/home-manager
    # Provides a basic system for managing a user environment.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/nix-community/disko/tree/master
    # Disc partitioning and declaration
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/feschber/lan-mouse
    # Cross-platform mouse and keyboard sharing software.
    lan-mouse.url = "github:feschber/lan-mouse";
    
    # https://github.com/musnix/musnix/
    # A collection of optimization options for realtime audio
    musnix.url = "github:musnix/musnix";


    # DE
    # ags.url = "github:Aylur/ags";

  };
}
