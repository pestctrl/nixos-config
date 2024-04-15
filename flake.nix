{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    update.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bashcfg-input = {
      url = "github:pestctrl/bash-config/master";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, update, unstable, home-manager, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstable-overlay = final: prev: {
        unstable = import unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      update-overlay = final: prev: {
        update = import update {
          inherit system;
          config.allowUnfree = true;
        };
      };
      # Perhaps this could've been presented as an overlay?
      # bashcfg-overlay = final: prev: {
      # };
    in {

      nixosConfigurations = {
        NixFrame = nixpkgs.lib.nixosSystem {
          inherit system;
          # specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ unstable-overlay update-overlay ]; }
            nixos-hardware.nixosModules.framework-13-7040-amd
            ./hosts/NixFrame/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.benson.imports = [ ./home/home.nix ];
            }
          ];
        };

        NixDawn = nixpkgs.lib.nixosSystem {
          inherit system;
          # specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ unstable-overlay update-overlay ]; }
            ./hosts/NixDawn/configuration.nix
            home-manager.nixosModule
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.benson.imports = [ ./home/home.nix ];
              };
            }
          ];
        };

        NixGate = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ unstable-overlay update-overlay ]; }
            ./hosts/NixGate/configuration.nix
          ];
        };

        # nixosConfigurations.LenoNix = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [ ./hosts/NixFrame/configuration.nix ];
        # };
      };

      homeConfigurations."benson" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home/home.nix
        ];
      };
    };
}
