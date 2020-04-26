{ config, lib, pkgs, ... }:

{
  # Configure systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1;

  # Set hostname
  networking.hostName = "R3600";

  # Enable CPU microcode updates
  hardware.cpu.amd.updateMicrocode = true;

  # Needed for the time to stay in sync when dual booting Linux and Windows
  time.hardwareClockInLocalTime = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;

  # The 32-bit host ID of this machine, formatted as 8 hexadecimal characters.
  # generated via "head -c 8 /etc/machine-id"
  # this is required by ZFS
  networking.hostId = "db43f9bb";

  # Enable Bluetooth support
  hardware.bluetooth.enable = true;

  # Use full PulseAudio package for Bluetooth support
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # Enable weekly TRIM on ZFS
  services.zfs.trim.enable = true;

  # Add ddcci module for controlling the monitor through DDC
  boot.extraModulePackages = [ pkgs.unstable.linuxPackages_5_5.ddcci-driver ];
  boot.kernelModules = [ "ddcci" ];

  # Use Linux kernel 5.5, this fixes screen flickering after suspend
  boot.kernelPackages = pkgs.unstable.linuxPackages_5_5;

  # Install amdvlk driver, some games have graphical glitches when using mesa
  # Can be enabled by setting VK_ICD_FILENAMES=/nix/store/<hash>-amdvlk-2020.Q1.2/share/vulkan/icd.d/amd_icd64.json
  environment.systemPackages = with pkgs; [
    amdvlk
  ];

  # Use the amdgpu video driver
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable Freesync
  # Enable TearFree, this forces vsync globally and fixes apps with
  # a broken vsync implementation
  services.xserver.deviceSection = ''
    Option "VariableRefresh" "true"
    Option "TearFree" "true"
  '';

  # Use ACO shader compiler globally
  environment.variables = {
    "RADV_PERFTEST" = "aco";
  };

  # Setup qemu user
  qemu-user.aarch64 = true;
  qemu-user.arm = true;
}
