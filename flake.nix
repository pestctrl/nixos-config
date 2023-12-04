{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.NixFrame = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/NixFrame/configuration.nix ];
    };

    # nixosConfigurations.LenoNix = nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";
    #   modules = [ ./hosts/NixFrame/configuration.nix ];
    # };
  };
}
