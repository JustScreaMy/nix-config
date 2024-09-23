{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.krop.ide;
in
{
  options.krop.ide = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
    install-pycharm = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        zed-editor
        vscodium
      ]
      ++ lib.optionals cfg.install-pycharm [ pkgs.jetbrains.pycharm-professional ];
  };
}
