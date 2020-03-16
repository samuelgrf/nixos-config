{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.lux;
in
{
  options = {
    hardware.lux = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Wether install the Lux package and add udev rules granting access to
          brightness files for members of the "video" group.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = with pkgs; [ lux ];
  };
}
