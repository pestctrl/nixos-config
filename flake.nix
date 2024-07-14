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
      mkSystem = h: {
        "${h}" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./common/configuration.nix
            (./. + "/hosts/${h}/configuration.nix")
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.benson.imports = [ ./home/home.nix ];
            }
          ];
        };
      };
    in {

      nixosConfigurations =
        (nixpkgs.lib.foldr (a: b: a // b) {}
          (map mkSystem ["NixDawn" "NixFrame"])) // {
        NixGate = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./common/configuration.nix
            ./hosts/NixGate/configuration.nix
          ];
        };

        NixSentinel = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./common/configuration.nix
            ./hosts/NixSentinel/configuration.nix
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
