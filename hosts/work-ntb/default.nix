{config, pkgs, inputs, ...}: {
    imports = [
        (import ../base {inherit config pkgs; hostname = "work-ntb"; })
    ];

    # My own modules configuration
    krop = {
        ide = {
            enable = true;
            install-pycharm = true;
        };
        python.install-older = true;
    };

    home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users = {
            "krop" = import ./home.nix;
        };
    };
}
