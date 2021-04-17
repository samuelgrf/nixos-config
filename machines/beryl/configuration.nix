{ amdvlk, config, pkgsi686Linux, ... }: {

  ##############################################################################
  ## General
  ##############################################################################

  # Set hostname.
  networking.hostName = "beryl";

  # The 32-bit host ID of this machine, formatted as 8 hexadecimal characters.
  # This is generated via `head -c 8 /etc/machine-id` and required by ZFS.
  networking.hostId = "db43f9bb";

  # Enable systemd-boot and set timeout.
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 3;

  # Enable weekly TRIM on ZFS.
  services.zfs.trim.enable = true;


  ##############################################################################
  ## Xorg & Services
  ##############################################################################

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;


  ##############################################################################
  ## Kernel & Modules
  ##############################################################################

  # Install kernel modules.
  boot.extraModulePackages = with config.boot.kernelPackages;
    [ hid-playstation ];


  ##############################################################################
  ## GPU
  ##############################################################################

  # Use the amdgpu video driver.
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Install AMDVLK driver, as some games have graphical glitches when using RADV.
  # Can be enabled by setting
  # VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json:/run/opengl-driver-32/share/vulkan/icd.d/amd_icd32.json
  hardware.opengl.extraPackages = [ amdvlk ];
  hardware.opengl.extraPackages32 = with pkgsi686Linux; [ amdvlk ];

  # Set global environment variables.
  environment.variables.VK_ICD_FILENAMES =
    "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";

  # Enable Freesync and TearFree (hardware vsync).
  services.xserver.deviceSection = ''
    Option "VariableRefresh" "true"
    Option "TearFree" "true"
  '';


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
