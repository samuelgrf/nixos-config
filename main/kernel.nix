{ config, lib, linuxPackages_xanmod, ... }: {

  # Use XanMod kernel for better interactive performance.
  boot.kernelPackages = linuxPackages_xanmod;

  # TODO Remove once OpenZFS is updated to 2.1.0.
  boot.zfs.enableUnstable = true; # Supports Linux 5.12.

  # Enable support for additional filesystems.
  boot.supportedFilesystems = [ "exfat" "ntfs" "zfs" ];
  networking.hostId = lib.mkHostId config.networking.hostName; # Needed by ZFS.

  # Enable zram and use faster lzo compression.
  zramSwap.enable = true;
  zramSwap.algorithm = "lzo";

}
