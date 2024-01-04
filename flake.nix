{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      unstable-overlay = final: prev: {
        unstable = import unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in {

      nixosConfigurations.NixFrame = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          home-manager.nixosModule
          { nixpkgs.overlays = [ unstable-overlay ]; }
          ./hosts/NixFrame/configuration.nix
        ];
      };

      nixosConfigurations.NixDawn = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          { nixpkgs.overlays = [ unstable-overlay ]; }
          ./hosts/NixDawn/configuration.nix
        ];
      };

      nixosConfigurations.NixAdvantage = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          { nixpkgs.overlays = [ unstable-overlay ]; }
          ./hosts/NixAdvantage/configuration.nix
        ];
      };

      # nixosConfigurations.LenoNix = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [ ./hosts/NixFrame/configuration.nix ];
      # };
    };
}
