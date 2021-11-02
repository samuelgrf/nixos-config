{ amdvlk, linuxLTOPackages_zen_zen2, pkgsi686Linux, ... }: {

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

  # Enable the X11 windowing system.
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
  hardware.opengl.extraPackages = [ amdvlk ];
  hardware.opengl.extraPackages32 = with pkgsi686Linux; [ amdvlk ];

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
