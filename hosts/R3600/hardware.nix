{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "amdgpu" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices.luksroot =
    { device = "/dev/disk/by-uuid/85109cb2-7c95-40d2-9903-8c173912c743";
      allowDiscards = true;
    };

  fileSystems."/" =
    { device = "rpool/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "rpool/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5E3B-2784";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-partuuid/140325f2-7a11-49cb-8059-451c7d83f8e9";
        randomEncryption.enable = true;
      }
    ];

  nix.maxJobs = lib.mkDefault 12;
}
