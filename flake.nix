{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    update.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, update, unstable, home-manager, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = import ./common/overlays.nix inputs;
      };
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
        (pkgs.lib.foldr (a: b: a // b) {}
          (map mkSystem ["NixDawn" "NixFrame"]))

        // {
        NixGate = pkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./common/configuration.nix
            ./hosts/NixGate/configuration.nix
          ];
        };

        NixSentinel = pkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./common/configuration.nix
            ./hosts/NixSentinel/configuration.nix
          ];
        };

        # LenoNix = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [ ./hosts/NixFrame/configuration.nix ];
        # };
      };

      devShells."${system}" = {
        default = pkgs.mkShell {
          # packages = with pkgs; [mps-debug];
          # nativeBuildInputs = with pkgs; [ mps-debug ] ++ pkgs.emacs.nativeBuildInputs;
          # buildInputs = pkgs.emacs.buildInputs;
          packages = with pkgs; [ mps-debug ];
          inputsFrom = with pkgs; [ emacs ];

          shellHook = ''
            export MPS_LIB="${pkgs.mps-debug}/lib"
            export MPS_INC="${pkgs.mps-debug}/include"
            echo "MPS debug environment!"
            echo "MPS_LIB = $MPS_LIB"
            echo "MPS_INC = $MPS_INC"
          '';
        };
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
