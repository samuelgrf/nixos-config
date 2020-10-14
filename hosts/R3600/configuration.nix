{ config, pkgs, ... }:

{
  ##############################################################################
  ## General
  ##############################################################################

  # Set hostname.
  networking.hostName = "R3600";

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
  ## GPU
  ##############################################################################

  # Use the amdgpu video driver.
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Get Mesa from unstable.
  hardware.opengl.package = pkgs.unstable.mesa.drivers;
  hardware.opengl.package32 = pkgs.unstable.driversi686Linux.mesa.drivers;

  # Install AMDVLK driver, since some games have graphical glitches when using RADV.
  # Can be enabled by setting
  # VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json:/run/opengl-driver-32/share/vulkan/icd.d/amd_icd32.json
  hardware.opengl.extraPackages = with pkgs.unstable; [ amdvlk ];
  hardware.opengl.extraPackages32 = with pkgs.unstable.driversi686Linux; [ amdvlk ];

  # Set global environment variables.
  environment.variables = {
    RADV_PERFTEST = "aco";
    VK_ICD_FILENAMES =
      "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";
  };

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
}
