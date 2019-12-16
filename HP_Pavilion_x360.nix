{ config, pkgs, ... }:

{
  # The 32-bit host ID of this machine, formatted as 8 hexadecimal characters.
  # generated via "head -c 8 /etc/machine-id"
  # this is required by ZFS
  networking.hostId = "52623593";

  # Install wifi kernel module
  boot.extraModulePackages = with pkgs; [ pkgs.linuxPackages.rtl8821ce ];

  # Blacklist sensor kernel modules
  boot.blacklistedKernelModules = [ "intel_ishtp_hid" "intel_ish_ipc" ];

  # Blacklist power management for wifi card as it may cause issues
  services.tlp.extraConfig = "RUNTIME_PM_BLACKLIST='02:00.0'";
}
