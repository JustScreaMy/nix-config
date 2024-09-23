{
  config,
  pkgs,
  lib,
  ...
}@inputs:
let
  cfg = config.krop.devtools;
in
{
  imports = [
    ./python.nix
    ./ide.nix
  ];
  options.krop.devtools = {
    installTools = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
      description = "Whether to install the most used tools";
    };
  };

  config =
    let
      tools = with pkgs; [
        lazygit
        lazydocker
        micro-with-wl-clipboard
        albert
        openssl_3_3
      ];
    in
    {
      environment.systemPackages = tools;
    };
}
