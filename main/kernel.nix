{ unstable, ... }: {

  # Use Zen kernel for better interactive performance.
  # TODO Remove "unstable." on 21.05.
  boot.kernelPackages = unstable.linuxPackages_zen;

  # Enable support for additional filesystems.
  boot.supportedFilesystems = [ "exfat" "ntfs" "zfs" ];

  # Enable zram and use faster lzo compression.
  zramSwap.enable = true;
  zramSwap.algorithm = "lzo";

  # Set swappiness to 80 due to improved performance of zram.
  # Can be up to 100, but will increase process queue on intense load such as boot.
  boot.kernel.sysctl."vm.swappiness" = 80;

}
