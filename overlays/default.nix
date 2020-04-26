{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      unstable = import <nixos-unstable> {
        config = config.nixpkgs.config;
        overlays = config.nixpkgs.overlays;
        localSystem = config.nixpkgs.localSystem;
        crossSystem = config.nixpkgs.crossSystem;
      };
      amdvlk = super.callPackage ./amdvlk { };
      g810-led = super.callPackage ./g810-led { };
      lux = super.callPackage ./lux { };
      gamemode = super.callPackage ./gamemode { };
      rpcs3 = super.callPackage ./rpcs3 {
        stdenv = super.impureUseNativeOptimizations super.stdenv;
      };
      multimc = super.libsForQt5.callPackage ./multimc { };
      emacs-nox = pkgs.emacs.override {
        withX = false;
        withGTK2 = false;
        withGTK3 = false;
      };
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
