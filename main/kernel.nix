{ config, lib, pkgs-unstable, ... }: {

  # Use Zen kernel for better interactive performance.
  # TODO Remove `pkgs-unstable.` on NixOS 21.11.
  boot.kernelPackages = lib.mkDefault pkgs-unstable.linuxLTOPackages_zen;

  # Enable support for additional filesystems.
  boot.supportedFilesystems = [ "exfat" "ntfs" "zfs" ];
  networking.hostId = lib.mkHostId config.networking.hostName; # Needed by ZFS.

  # Enable zram and use faster lzo-rle compression.
  zramSwap.enable = true;
  zramSwap.algorithm = "lzo-rle";
}
