{ linuxLTOPackages_zen_skylake, pkgsi686Linux, vaapiIntel, ... }: {

  ##############################################################################
  ## General
  ##############################################################################

  # Set hostname.
  networking.hostName = "amethyst";

  # Enable systemd-boot and set timeout.
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1

  ;
  ##############################################################################
  ## Services
  ##############################################################################

  # Enable display server.
  services.xserver.enable = true;
  services.xserver.autorun = true;

  # Enable TLP for improved battery life.
  services.tlp.enable = true

  ;
  ##############################################################################
  ## Kernel
  ##############################################################################

  # Use Zen kernel with platform optimizations.
  boot.kernelPackages = linuxLTOPackages_zen_skylake;

  # Blacklist sensor kernel modules.
  boot.blacklistedKernelModules = [ "intel_ishtp_hid" "intel_ish_ipc" ]

  ;
  ##############################################################################
  ## Other hardware
  ##############################################################################

  # Configure touchpad behavior.
  services.xserver.libinput.touchpad = {
    disableWhileTyping = true;
    naturalScrolling = true;
    tapping = true;
  };

  # Enable Bluetooth support.
  hardware.bluetooth.enable = true;

  # Install libraries for VA-API.
  hardware.opengl.extraPackages = [ vaapiIntel ];
  hardware.opengl.extraPackages32 = with pkgsi686Linux; [ vaapiIntel ];

  # Enable CPU microcode updates.
  hardware.cpu.intel.updateMicrocode = true;

  # Configure lm_sensors.
  environment.etc."sysconfig/lm_sensors".text = "HWMON_MODULES=coretemp";
}
