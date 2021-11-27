{ amdvlk, linuxLTOPackages_zen_zen2, mesa_ANGLE, pkgsi686Linux, ... }: {

  ##############################################################################
  ## General
  ##############################################################################

  # Set hostname.
  networking.hostName = "beryl";

  # Enable systemd-boot and set timeout.
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 5

  ;
  ##############################################################################
  ## Services
  ##############################################################################

  # Enable display server.
  services.xserver.enable = true;
  services.xserver.autorun = true

  ;
  ##############################################################################
  ## Kernel
  ##############################################################################

  # Use Zen kernel with platform optimizations.
  boot.kernelPackages = linuxLTOPackages_zen_zen2

  ;
  ##############################################################################
  ## GPU
  ##############################################################################

  # Install AMDVLK driver, as some games have graphical glitches when using RADV.
  # Can be enabled by setting `AMD_VULKAN_ICD=AMDVLK`.
  hardware.opengl = {
    extraPackages = [ amdvlk ];
    extraPackages32 = with pkgsi686Linux; [ amdvlk ];

    # Use patched Mesa with `ANGLE_sync_control_rate` support.
    # See https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/5139
    package = mesa_ANGLE;
    package32 = pkgsi686Linux.mesa_ANGLE;
  };

  # Set global environment variables.
  environment.variables.AMD_VULKAN_ICD = "RADV";

  # Enable Freesync and TearFree (hardware vsync).
  services.xserver.deviceSection = ''
    Option "VariableRefresh" "true"
    Option "TearFree" "true"
  ''

  ;
  ##############################################################################
  ## Other hardware
  ##############################################################################

  # Enable Bluetooth support.
  hardware.bluetooth.enable = true;

  # Enable CPU microcode updates.
  hardware.cpu.amd.updateMicrocode = true;

  # Needed for the time to stay in sync when dual booting Linux and Windows.
  time.hardwareClockInLocalTime = true;

  # Configure lm_sensors.
  environment.etc."sysconfig/lm_sensors".text = "HWMON_MODULES=nct6775";
}
