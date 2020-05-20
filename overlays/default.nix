{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      # Alias for unstable channel
      unstable = import <nixos-unstable> {
        config = config.nixpkgs.config;
        overlays = config.nixpkgs.overlays;
        localSystem = config.nixpkgs.localSystem;
        crossSystem = config.nixpkgs.crossSystem;
      };

      ### APPLICATIONS

      emacs-nox = pkgs.emacs.override {
        withX = false;
        withGTK2 = false;
        withGTK3 = false;
      };

      pcsx2_NativeOptimizations = super.pkgs.pkgsi686Linux.pcsx2.override {
        stdenv = super.pkgs.pkgsi686Linux.impureUseNativeOptimizations super.pkgs.pkgsi686Linux.stdenv;
      };

      rpcs3 = super.callPackage ./rpcs3 {
        stdenv = super.impureUseNativeOptimizations super.stdenv;
      };

      ### TOOLS

      g810-led = super.callPackage ./g810-led { };

      gamemode32 = super.callPackage_i686 ./gamemode32 { };
      gamemode = super.callPackage ./gamemode { };

      inih = super.callPackage ./inih { }; # GameMode dependency

      lux = super.callPackage ./lux { };

      w7zip = super.callPackage ./w7zip { };

      ### MISC

      amdvlk = super.callPackage ./amdvlk { };

      linuxPackages = super.linuxPackages.extend (self: super: {
        rtl8821ce = super.callPackage ./rtl8821ce { };
      });

      # Copied from https://github.com/cleverca22/nixos-configs/blob/master/overlays/qemu/default.nix
      qemu-user-arm = if self.stdenv.system == "x86_64-linux"
        then self.pkgsi686Linux.callPackage ./qemu-user { user_arch = "arm"; }
        else self.callPackage ./qemu-user { user_arch = "arm"; };
      qemu-user-x86 = self.callPackage ./qemu-user { user_arch = "x86_64"; };
      qemu-user-arm64 = self.callPackage ./qemu-user { user_arch = "aarch64"; };
      qemu-user-riscv32 = self.callPackage ./qemu-user { user_arch = "riscv32"; };
      qemu-user-riscv64 = self.callPackage ./qemu-user { user_arch = "riscv64"; };
    })
  ];
}
