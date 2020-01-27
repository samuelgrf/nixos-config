{ config, lib, pkgs, ... }:

{
  # The 32-bit host ID of this machine, formatted as 8 hexadecimal characters.
  # generated via "head -c 8 /etc/machine-id"
  # this is required by ZFS
  networking.hostId = "97e4f3b3";

  # Install wifi kernel module
  boot.extraModulePackages = [ pkgs.linuxPackages.rtl8821ce ];

  # Blacklist sensor kernel modules
  boot.blacklistedKernelModules = [ "intel_ishtp_hid" "intel_ish_ipc" ];

  # Blacklist power management for wifi card as it may cause issues
  services.tlp.extraConfig = "RUNTIME_PM_BLACKLIST='02:00.0'";

  # Install additional packages
  environment.systemPackages = with pkgs; [
    alsaTools
    libva-utils
  ];

  # Create a systemd service to fix audio crackling on startup/resume
  systemd.services.fixaudio = {
    description = "Fix audio crackling on Realtek ALC295";
    script = "${pkgs.alsaTools}/bin/hda-verb /dev/snd/hwC[[:print:]]*D0 0x20 SET_COEF_INDEX 0x67
              ${pkgs.alsaTools}/bin/hda-verb /dev/snd/hwC[[:print:]]*D0 0x20 SET_PROC_COEF 0x3000";
    wantedBy = [ "multi-user.target" "post-resume.target" ];
    after = [ "post-resume.target" ];
  };

  # Install libraries for VA-API
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  # Always start mpv with VA-API enabled
  environment.shellAliases = {
    "mpv" = "mpv --vo=vaapi --hwdec=vaapi";
  };

  # Enable Bluetooth support
  hardware.bluetooth.enable = true;

  # Use full PulseAudio package for Bluetooth support
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # Enable weekly TRIM on ZFS
  services.zfs.trim.enable = true;
}
