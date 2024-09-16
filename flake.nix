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

  outputs = inputs@{ self, nixpkgs, ... }: {
    # Please replace my-nixos with your hostname
    nixosConfigurations = {
        work-ntb = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./hosts/work-ntb
                inputs.nix-flatpak.nixosModules.nix-flatpak
                inputs.home-manager.nixosModules.home-manager
            ];
            specialArgs = {
                hostname = "work-ntb";
                };
            };
            extraSpecialArgs = {
                inherit inputs;
            };
        };
    };
}
