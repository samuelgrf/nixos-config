{ config, pkgs, ... }:

{
  # Use Zen kernel for better interactive performance.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Load kernel module for ddcutil.
  boot.kernelModules = [ "i2c-dev" ];

  # Enable support for additional filesystems.
  boot.supportedFilesystems = [ "ntfs" "zfs" ];

  # Enable zram and use faster lzo compression.
  zramSwap.enable = true;
  zramSwap.algorithm = "lzo";

  # Set swappiness to 80 due to improved performance of zram.
  # Can be up to 100, but will increase process queue on intense load such as boot.
  boot.kernel.sysctl = { "vm.swappiness" = 80; };
}
