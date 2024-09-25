{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  networking.hostName = "lenar"; # Define your hostname.

  # My own modules configuration
  krop = {
    ide = {
      enable = true;
      install-pycharm = true;
    };
    python.install-older = true;
  };

  systemd.services.configure-mic-leds = rec {
    wantedBy = [ "sound.target" ];
    after = wantedBy;
    serviceConfig.Type = "oneshot";
    script = ''
      echo follow-route > /sys/class/sound/ctl-led/mic/mode
    '';
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "krop" = import ../../users/krop;
    };
  };
}
