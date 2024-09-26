{
  config,
  pkgs,
  lib,
  ...
}@inputs:
{
  imports = [
    ./python.nix
    ./ide.nix
    ./cli.nix
    ./docker.nix
  ];
}
