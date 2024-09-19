{ config, pkgs, lib, ... }@inputs:
let
    cfg = config.krop.devtools;
in {
    options.krop.devtools = {
        installIDE = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Whether to install the ides";
        };
        installTools = lib.mkOption {
            type = lib.types.bool;
            default = true;
            example = true;
            description = "Whether to install the most used tools";
        };
    };
    config = let
        ides = with pkgs; [
            jetbrains.pycharm-professional
            zed-editor
			vscodium
        ];
        languages = with pkgs; [
            python3
            python311
            python310
			poetry
        ];
        tools = with pkgs; [
            lazygit
            lazydocker
            micro-with-wl-clipboard
            albert
            openssl_3_3
        ];
    in {
        environment.systemPackages = languages
            ++ (lib.optionals cfg.installIDE ides)
            ++ (lib.optionals cfg.installTools tools);
    };
}
