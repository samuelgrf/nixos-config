{ config, pkgs, lib, ... }:

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
        Wether to apply a g810-led profile after boot and when a compatible
        keyboard is connected.
      '';
    };

    profile = mkOption {
      type = types.path;
      description = ''
        The profile file to be applied. Samples can be found at:
        https://github.com/MatMoul/g810-led/tree/master/sample_profiles
      '';
    };

    vendorId = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Set a custom USB vendor ID.
      '';
    };

    productId = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Set a custom USB product ID.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.g810-led ];
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c336", MODE="666" RUN+="${pkgs.g810-led}/bin/g213-led -p ${cfg.profile}"
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c330", MODE="666" RUN+="${pkgs.g810-led}/bin/g410-led -p ${cfg.profile}"
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33a", MODE="666" RUN+="${pkgs.g810-led}/bin/g413-led -p ${cfg.profile}"
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c33c", MODE="666" RUN+="${pkgs.g810-led}/bin/g513-led -p ${cfg.profile}"
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c333", MODE="666" RUN+="${pkgs.g810-led}/bin/g610-led -p ${cfg.profile}"
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c338", MODE="666" RUN+="${pkgs.g810-led}/bin/g610-led -p ${cfg.profile}"
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c331", MODE="666" RUN+="${pkgs.g810-led}/bin/g810-led -p ${cfg.profile}"
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c337", MODE="666" RUN+="${pkgs.g810-led}/bin/g810-led -p ${cfg.profile}"
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c32b", MODE="666" RUN+="${pkgs.g810-led}/bin/g910-led -p ${cfg.profile}"
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c335", MODE="666" RUN+="${pkgs.g810-led}/bin/g910-led -p ${cfg.profile}"
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c339", MODE="666" RUN+="${pkgs.g810-led}/bin/gpro-led -p ${cfg.profile}"
      ${optionalString (cfg.vendorId != null && cfg.productId != null) ''
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="${cfg.vendorId}", ATTRS{idProduct}=="${cfg.productId}", MODE="666" RUN+="${pkgs.g810-led}/bin/g810-led -p ${cfg.profile} -dv ${cfg.vendorId} -dp ${cfg.productId}"
      ''}
      ${optionalString (cfg.vendorId == null && cfg.productId != null) ''
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idProduct}=="${cfg.productId}", MODE="666" RUN+="${pkgs.g810-led}/bin/g810-led -p ${cfg.profile} -dp ${cfg.productId}"
      ''}
      ${optionalString (cfg.vendorId != null && cfg.productId == null) ''
        ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="${cfg.vendorId}", MODE="666" RUN+="${pkgs.g810-led}/bin/g810-led -p ${cfg.profile} -dv ${cfg.vendorId}"
      ''}
    '';
  };
}
