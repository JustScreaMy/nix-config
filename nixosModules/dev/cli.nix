{
  config,
  pkgs,
  lib,
  ...
}@inputs:
let
  cfg = config.krop.cli;
in
{
  options.krop.cli = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
      description = "Whether to install the most used tools";
    };
    install-editors = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = true;
      description = "Whether to install cli editors";
    };
    install-k8s-tools = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Whether to install k8s tools";
    };
    install-cloud-cli = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Whether to install cloud providers CLI clients";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        openssl_3_3
        dig
        wl-clipboard
      ]
      ++ lib.optionals cfg.install-editors [
        pkgs.lazygit
        pkgs.lazydocker
        pkgs.micro-with-wl-clipboard
      ]
      ++ lib.optionals cfg.install-k8s-tools [
        pkgs.k9s
        pkgs.kubectl
        pkgs.kubectx
      ]
      ++ lib.optionals cfg.install-cloud-cli [
        pkgs.oci-cli
      ];
  };
}
