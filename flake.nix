{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bashcfg-input = {
      url = "github:pestctrl/bash-config/master";
      flake = false;
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
  };

  outputs = { self, nixpkgs, unstable, home-manager, bashcfg-input, ... }@inputs:
    let
      system = "x86_64-linux";
      unstable-overlay = final: prev: {
        unstable = import unstable {
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
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.nixosModule
            { nixpkgs.overlays = [ unstable-overlay ]; }
            ./hosts/NixFrame/configuration.nix
          ];
        };

        NixDawn = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            home-manager.nixosModule
            { nixpkgs.overlays = [ unstable-overlay ]; }
            ./hosts/NixDawn/configuration.nix
          ];
        };

        NixAdvantage = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            home-manager.nixosModule
            { nixpkgs.overlays = [ unstable-overlay ]; }
            ./hosts/NixAdvantage/configuration.nix
          ];
        };
      };

      # nixosConfigurations.LenoNix = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [ ./hosts/NixFrame/configuration.nix ];
      # };
    };
}
