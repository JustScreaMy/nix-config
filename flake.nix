{
  description = "My system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    {
      # Please replace my-nixos with your hostname
      nixosConfigurations = {
        work-ntb = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixosModules # TODO: move to base
            ./hosts/work-ntb
            ./hosts/base
          ];
        };
        extraSpecialArgs = {
          inherit (inputs) home-manager nix-flatpak;
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
