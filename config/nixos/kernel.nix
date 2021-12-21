{ config, lib, linuxPackages_zen_lto, ... }: {

  # Use Zen kernel for better interactive performance.
  boot.kernelPackages = lib.mkDefault linuxPackages_zen_lto;

  # Enable support for additional filesystems.
  boot.supportedFilesystems = [ "exfat" "ntfs" "zfs" ];
  networking.hostId = lib.mkHostId config.networking.hostName; # Needed by ZFS.

  # Enable zram and use faster lzo-rle compression.
  zramSwap.enable = true;
  zramSwap.algorithm = "lzo-rle";
}
