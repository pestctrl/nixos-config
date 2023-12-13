{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay/da2f552d133497abd434006e0cae996c0a282394";
  };

  outputs = { self, nixpkgs, ... }: {
    nixpkgs.overlays = [ (import self.inputs.emacs-overlay) ];

    nixosConfigurations.NixFrame = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/NixFrame/configuration.nix ];
    };

    nixosConfigurations.NixDawn = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/NixDawn/configuration.nix ];
    };

    # nixosConfigurations.LenoNix = nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";
    #   modules = [ ./hosts/NixFrame/configuration.nix ];
    # };
  };
}
