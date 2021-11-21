{ config, lib, linuxLTOPackages_zen, ... }: {

  # Use Zen kernel for better interactive performance.
  boot.kernelPackages = lib.mkDefault linuxLTOPackages_zen;

  # Enable support for additional filesystems.
  boot.supportedFilesystems = [ "exfat" "ntfs" "zfs" ];
  networking.hostId = lib.mkHostId config.networking.hostName; # Needed by ZFS.

  # Enable zram and use faster lzo-rle compression.
  zramSwap.enable = true;
  zramSwap.algorithm = "lzo-rle";
}
