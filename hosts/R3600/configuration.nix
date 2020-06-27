{ config, lib, pkgs, ... }:

{
  ##############################################################################
  ## General
  ##############################################################################

  # Set hostname
  networking.hostName = "R3600";

  # The 32-bit host ID of this machine, formatted as 8 hexadecimal characters.
  # generated via "head -c 8 /etc/machine-id"
  # this is required by ZFS
  networking.hostId = "db43f9bb";

  # Configure systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 3;

  # Enable weekly TRIM on ZFS
  services.zfs.trim.enable = true;


  ##############################################################################
  ## Xorg & Services
  ##############################################################################

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;

  # Install GameMode systemd service
  systemd.packages = [ pkgs.gamemode ];


  ##############################################################################
  ## Kernel & Modules
  ##############################################################################

  # Use experimental Linux kernel
  boot.kernelPackages = pkgs.unstable.linuxPackages_5_7;

  # Add ddcci module for controlling the monitor through DDC
  boot.extraModulePackages = [ pkgs.unstable.linuxPackages_5_7.ddcci-driver ];
  boot.kernelModules = [ "ddcci" ];


  ##############################################################################
  ## GPU
  ##############################################################################

  # Use the amdgpu video driver
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Install AMDVLK driver, some games have graphical glitches when using RADV
  # Can be enabled by setting VK_ICD_FILENAMES=/run/current-system/sw/share/amdvlk/icd.d/amd_icd64.json
  environment.systemPackages = with pkgs; [
    amdvlk_noDefault
  ];

  # Use ACO shader compiler globally
  environment.variables = {
    "RADV_PERFTEST" = "aco";
  };

  # Enable Freesync and TearFree (hardware vsync)
  services.xserver.deviceSection = ''
    Option "VariableRefresh" "true"
    Option "TearFree" "true"
  '';


  ##############################################################################
  ## Other hardware
  ##############################################################################

  # Enable Bluetooth support
  hardware.bluetooth.enable = true;

  # Enable CPU microcode updates
  hardware.cpu.amd.updateMicrocode = true;

  # Needed for the time to stay in sync when dual booting Linux and Windows
  time.hardwareClockInLocalTime = true;
}
