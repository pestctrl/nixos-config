{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    update.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, update, unstable, home-manager, nixos-hardware, emacs-overlay, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays =
          [emacs-overlay.overlays.default] ++
          (import ./common/overlays.nix inputs);
      };
      mkSystem = h: {
        "${h}" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            (./. + "/hosts/${h}/configuration.nix")
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.benson.imports = [ ./home/users/benson.nix ];
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

      packages."${system}" = {
        mps-debug = pkgs.mps-debug;
      };

      devShells."${system}" = {
        default = pkgs.mkShell {
          # packages = with pkgs; [mps-debug];
          # nativeBuildInputs = with pkgs; [ mps-debug ] ++ pkgs.emacs.nativeBuildInputs;
          # buildInputs = pkgs.emacs.buildInputs;
          # packages = with pkgs; [ mps-debug ];
          inputsFrom = with pkgs; [ emacs ];
          packages = with pkgs; [ mps ];

          shellHook = ''
            export MPS_LIB="${pkgs.mps-debug}/lib"
            export MPS_INC="${pkgs.mps-debug}/include"
            echo "MPS debug environment!"
            echo "MPS_LIB = $MPS_LIB"
            echo "MPS_INC = $MPS_INC"
            echo "Configure Command: "
            echo -n '  LDFLAGS="-L$MPS_LIB" CFLAGS="-O0 -g3 -isystem $MPS_INC" '
            echo './configure --with-mps=debug --with-native-compilation=no --enable-checking="yes,glyphs"'
            echo "If you are using Emacs from emacs-overlay, remember to unset environment variable EMACSLOADPATH"
            echo "Need to investigate further as to why"
          '';
        };
      };

      homeConfigurations = {
        "benson" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/users/benson.nix
          ];
        };

        "work" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/users/work.nix
          ];
        };
      };
    };
}
