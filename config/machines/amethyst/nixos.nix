{ binPaths, linuxLTOPackages_zen_skylake, pkgsi686Linux, vaapiIntel, ... }: {

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

  # Enable the X11 windowing system.
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
  ## Audio
  ##############################################################################

  # Create a systemd service to fix sound crackling after resume/startup.
  # https://bugs.launchpad.net/ubuntu/+source/alsa-driver/+bug/1648183/comments/17
  systemd.services.sound-crackling-workaround = {
    description = "Sound crackling workaround for Realtek ALC295";
    script = with binPaths; ''
      until [ -e /dev/snd/hwC0D0 ]; do sleep 1; done
      ${hda-verb} /dev/snd/hwC0D0 0x20 SET_COEF_INDEX 0x67
      ${hda-verb} /dev/snd/hwC0D0 0x20 SET_PROC_COEF 0x3000
    '';
    wantedBy = [ "multi-user.target" "post-resume.target" ];
    after = [ "post-resume.target" ];
  }

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
