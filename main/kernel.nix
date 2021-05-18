{ config, lib, linuxPackages_zen, ... }: {

  # Use Zen kernel for better interactive performance.
  boot.kernelPackages = linuxPackages_zen;
  boot.zfs.enableUnstable = true; # Supports Linux 5.12.

  # Enable support for additional filesystems.
  boot.supportedFilesystems = [ "exfat" "ntfs" "zfs" ];
  networking.hostId = lib.mkHostId config.networking.hostName; # Needed by ZFS.

  # Enable zram and use faster lzo compression.
  zramSwap.enable = true;
  zramSwap.algorithm = "lzo";

}
