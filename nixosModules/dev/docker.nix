{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.krop.docker;
in
{
  options.krop.docker = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Whether to enable Docker service.";
    };
    addUserToGroup = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = "Whether to add the user to the Docker group.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
    };
    users.users.krop = lib.mkIf cfg.addUserToGroup {
      extraGroups = ["docker"];
    };
  };
}
