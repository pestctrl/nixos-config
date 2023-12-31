{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # emacs-overlay.url = "github:nix-community/emacs-overlay/da2f552d133497abd434006e0cae996c0a282394";
  };

  outputs = { self, nixpkgs, unstable, ... }:
    let
      system = "x86_64-linux";
      unstable-overlay = final: prev: {
        unstable = unstable.legacyPackages.${prev.system};
      };
    in {

      nixosConfigurations.NixFrame = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
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

      # nixosConfigurations.LenoNix = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   modules = [ ./hosts/NixFrame/configuration.nix ];
      # };
    };
}
