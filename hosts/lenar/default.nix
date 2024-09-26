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
    python = {
      enable = true;
      install-older = true;
    };
    cli = {
      enable = true;
      install-k8s-tools = true;
      install-cloud-cli = true;
    };
  };

  systemd.services.configure-mic-leds = rec {
    wantedBy = [ "sound.target" ];
    after = wantedBy;
    serviceConfig.Type = "oneshot";
    script = ''
      echo off > /sys/class/sound/ctl-led/mic/mode
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
