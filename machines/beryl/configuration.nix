{ amdvlk, pkgsi686Linux, ... }: {

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
  ## GPU
  ##############################################################################

  # Use the amdgpu video driver.
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Install AMDVLK driver, as some games have graphical glitches when using RADV.
  # Can be enabled by setting
  # TODO Update variable to `AMD_VULKAN_ICD=AMDVLK` on 21.05.
  # `VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json:/run/opengl-driver-32/share/vulkan/icd.d/amd_icd32.json`.
  hardware.opengl.extraPackages = [ amdvlk ];
  hardware.opengl.extraPackages32 = with pkgsi686Linux; [ amdvlk ];

  # Set global environment variables.
  # TODO Change to environment.variables.AMD_VULKAN_ICD = "RADV"; on 21.05.
  environment.variables.VK_ICD_FILENAMES =
    "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";

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
