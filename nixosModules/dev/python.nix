{ config, pkgs, lib, ... }:
let
	cfg = config.krop.python; 
in {
  	options.krop.python = {
        enable = lib.mkOption {
            type = lib.types.bool;
            default = lib.mkOptionDefault false;
            example = true;
        };
        install-older = lib.mkOption {
            type = lib.types.bool;
            default = lib.mkOptionDefault true;
            example = true;
        };
  	};

    config = lib.mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            python3
			poetry
        ] ++ lib.optionals cfg.install-older [python311 python310];
    };
}