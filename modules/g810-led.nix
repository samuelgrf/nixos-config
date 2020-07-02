{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.g810-led;
in
{
  options.hardware.g810-led = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Wether to apply a g810-led profile when a compatible keyboard
        is connected.
      '';
    };

    profile = mkOption {
      type = types.path;
      description = ''
        The profile file to be applied, samples can be found at:
        https://github.com/MatMoul/g810-led/tree/master/sample_profiles
      '';
    };

    enableFlashingWorkaround = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Wether to turn off all key LEDs on shutdown and reboot.
        Some keyboards flash 3 times on boot, this option works around that.
      '';
    };
  };

  config = mkIf cfg.enable {

    services.udev.packages = [
      (pkgs.g810-led.override {
        profile = cfg.profile;
      })
    ];

    # https://github.com/MatMoul/g810-led/blob/master/systemd/g810-led-reboot.service
    systemd.services.g810-led-workaround = mkIf cfg.enableFlashingWorkaround {
      description = "Turn off all g810-led keys";
      script = "${pkgs.g810-led}/bin/g810-led -a 000000";

      serviceConfig.Type = "oneshot";
      unitConfig.DefaultDependencies = false;

      wantedBy = [ "shutdown.target" ];
      before = [ "shutdown.target" "reboot.target" "halt.target" ];
    };
  };
}
