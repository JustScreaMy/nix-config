{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.krop.python;
in
{
  options.krop.python = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
    install-older = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        python3
        poetry
        pre-commit
      ]
      ++ lib.optionals cfg.install-older [
        python311
        python310
      ];
  };
}
