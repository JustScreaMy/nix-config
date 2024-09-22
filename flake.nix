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

    disko.url = "github:nix-community/disko";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    {
      # Please replace my-nixos with your hostname
      nixosConfigurations = {
        work-ntb = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/work-ntb
            ./hosts/base
          ];
          specialArgs = {
            inherit inputs;
          };
        };
        lenar = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/lenar
            ./hosts/base
            inputs.disko.nixosModules.disko
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
