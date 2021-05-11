{ config, pkgsi686Linux, vaapiIntel, ... }: {

  ##############################################################################
  ## General
  ##############################################################################

  # Set hostname.
  networking.hostName = "amethyst";

  # The 32-bit host ID of this machine, formatted as 8 hexadecimal characters.
  # This is generated via `head -c 8 /etc/machine-id` and required by ZFS.
  networking.hostId = "97e4f3b3";

  # Enable systemd-boot and set timeout.
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1

  ;
  ##############################################################################
  ## Xorg & Services
  ##############################################################################

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;

  # Enable TLP for improved battery life.
  services.tlp.enable = true;

  # Configure undervolting service for Intel CPUs.
  services.undervolt = {
    enable = true;
    coreOffset = -100;
    gpuOffset = -50;
    uncoreOffset = -100;
    analogioOffset = -100;
  }

  ;
  ##############################################################################
  ## Kernel & Modules
  ##############################################################################

  # Install kernel modules.
  boot.extraModulePackages = with config.boot.kernelPackages; [
    hid-playstation
    rtw88
  ];

  # Blacklist sensor kernel modules.
  boot.blacklistedKernelModules = [ "intel_ishtp_hid" "intel_ish_ipc" ]

  ;
  ##############################################################################
  ## GPU & Audio
  ##############################################################################

  # Only enable modesetting video driver, if this isn't set other unused drivers
  # are also installed.
  services.xserver.videoDrivers = [ "modesetting" ];

  # [WIP] amethyst: Fix audio crackling via kernel parameter
  # Commented out models have been tested and don't work.
  # A list of models can be found at `<linux-src>/Documentation/sound/hd-audio/models.rst`.
  boot.kernelParams = [
    ("snd_hda_intel.model=" # +
      # "hp-gpio-led"
      # "alc295-hp-x360"
      # "hp-mute-led-mic1"
      # "hp-mute-led-mic2"
      # "hp-mute-led-mic3"
      # "hp-gpio-mic1"
      # "hp-line1-mic1"
      # "noshutup"
      # "hp-gpio4"
      # "hp-gpio-led"
      # "hp-gpio2-hotkey"
      # "alc295-disable-dac3"
      # "lenovo-spk-noise"
      # "dell-spk-noise"
      # "inv-dmic"
      # "pcm44k"
      # "alc295-hp-omen"
    )
  ]

  ;
  ##############################################################################
  ## Other hardware
  ##############################################################################

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

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
