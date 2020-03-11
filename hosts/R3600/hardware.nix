{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "amdgpu" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices = {
    luksroot.device = "/dev/disk/by-uuid/85109cb2-7c95-40d2-9903-8c173912c743";
    luksroot.allowDiscards = true;
  };

  fileSystems."/" = {
    device = "rpool/root/nixos";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5E3B-2784";
    fsType = "vfat";
  };

  swapDevices =
  [ {
      device = "/dev/disk/by-uuid/2460728b-5b3a-4f8b-9c2a-48265f228e2d";
      encrypted.enable = true;
      encrypted.label = "cryptswap";
      encrypted.blkDev = "/dev/disk/by-uuid/a06c0258-eed1-4a9e-8532-d6697efee5f9";
    }
  ];

  nix.maxJobs = lib.mkDefault 12;
}
