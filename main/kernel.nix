{ config, lib, linuxPackages_5_12, ... }: {

  # TODO Remove on NixOS 21.11.
  # Linux kernel 5.12 supports DualSense and RTL8821CE.
  boot.kernelPackages = linuxPackages_5_12;

  # TODO Remove once OpenZFS is updated to 2.1.0.
  boot.zfs.enableUnstable = true; # Supports Linux 5.12.

  # Enable support for additional filesystems.
  boot.supportedFilesystems = [ "exfat" "ntfs" "zfs" ];
  networking.hostId = lib.mkHostId config.networking.hostName; # Needed by ZFS.

  # Enable zram and use faster lzo-rle compression.
  zramSwap.enable = true;
  zramSwap.algorithm = "lzo-rle";

}
