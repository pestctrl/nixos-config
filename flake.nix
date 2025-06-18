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
        emacs-min = pkgs.mkShell {
          packages = with pkgs; [
            emacs
            git
            libtool
            cmake gcc gnumake
            roboto-mono ripgrep
          ];
        };

        emacs-devel = pkgs.mkShell {
          # packages = with pkgs; [mps-debug];
          # nativeBuildInputs = with pkgs; [ mps-debug ] ++ pkgs.emacs.nativeBuildInputs;
          # buildInputs = pkgs.emacs.buildInputs;
          # packages = with pkgs; [ mps-debug ];
          inputsFrom = with pkgs; [ emacs ];
          packages = with pkgs; [ mps ];
          buildInputs = with pkgs; [ xorg.libXrandr ];

          shellHook = ''
            echo "MPS debug environment!"
            set -x
            export MPS_LIB="${pkgs.mps-debug}/lib"
            export MPS_INC="${pkgs.mps-debug}/include"
            unset EMACSLOADPATH
            set +x
            echo "Configure Command: "
            echo -n '  LDFLAGS="-L$MPS_LIB" CFLAGS="-O0 -g3 -isystem $MPS_INC" '
            echo './configure --with-mps=debug --with-native-compilation=no --enable-checking="yes,glyphs"'
          '';
        };

        pymupdf = pkgs.mkShell {
          venvDir = "./venv";
          buildInputs = with pkgs.python312Packages; [
            venvShellHook
            python
            pymupdf
            icecream
          ];
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

        "a0487752" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home/users/work.nix
          ];
        };
      };
    };
}
