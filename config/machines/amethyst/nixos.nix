{ pkgs, pkgsi686Linux, ... }: {

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
  services.tlp.enable = true;

  # Hopefully fix system lock-ups by disabling power management for network controller.
  # Found here: https://h30434.www3.hp.com/t5/Notebooks-Archive-Read-Only/HP-Spectre-15-BL012DX-Completely-Freezes-Momentarily/m-p/6201824/highlight/true#M3144753
  services.tlp.settings = {
    RUNTIME_PM_BLACKLIST = "02:00.0";
    WIFI_PWR_ON_BAT = "off";
  };

  # How to find the ASPM register: https://wireless.wiki.kernel.org/en/users/documentation/aspm#how_to_find_the_link_control_register_on_a_pcie_device
  systemd.services.RTL8821CE-disable-aspm = {
    description = "Disable ASPM power management on RTL8821CE";
    script = "${pkgs.pciutils}/bin/setpci -s 00:1d.1 0x50.B=0x40";
    wantedBy = [ "multi-user.target" ];
  }

  ;
  ##############################################################################
  ## Kernel
  ##############################################################################

  # Use Zen kernel with platform optimizations.
  boot.kernelPackages = pkgs.linuxKernel.ltoPackages.linux_zen_skylake;

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
  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel ];
  hardware.opengl.extraPackages32 = with pkgsi686Linux; [ vaapiIntel ];

  # Enable CPU microcode updates.
  hardware.cpu.intel.updateMicrocode = true;

  # Configure lm_sensors.
  environment.etc."sysconfig/lm_sensors".text = "HWMON_MODULES=coretemp";
}
