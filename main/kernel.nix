{ config, lib, pkgs-unstable, ... }: {

  # Use Zen kernel for better interactive performance.
  # TODO Remove "pkgs-unstable." on 21.05.
  boot.kernelPackages = pkgs-unstable.linuxPackages_zen;
  boot.zfs.enableUnstable = true; # Supports Linux 5.12.

  # Enable support for additional filesystems.
  boot.supportedFilesystems = [ "exfat" "ntfs" "zfs" ];
  networking.hostId = lib.mkHostId config.networking.hostName; # Needed by ZFS.

  # Enable zram and use faster lzo compression.
  zramSwap.enable = true;
  zramSwap.algorithm = "lzo";

}
