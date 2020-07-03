{ config, ... }:

{
  nixpkgs.overlays = [
    (self: super: {

      ##########################################################################
      ## Channel aliases
      ##########################################################################

      # Alias for unstable channel
      unstable = import <nixos-unstable> {
        config = config.nixpkgs.config;
        overlays = config.nixpkgs.overlays;
        localSystem = config.nixpkgs.localSystem;
        crossSystem = config.nixpkgs.crossSystem;
      };


      ##########################################################################
      ## Applications
      ##########################################################################

      g810-led = super.callPackage ./g810-led { };

      pcsx2_nativeOptimizations = super.pkgs.pkgsi686Linux.pcsx2.override {
        stdenv = super.pkgs.pkgsi686Linux.impureUseNativeOptimizations super.pkgs.pkgsi686Linux.stdenv;
      };


      ##########################################################################
      ## Misc
      ##########################################################################

      # The Vulkan Loader tries to load the default driver from $share/vulkan/icd.d/
      # Prevent loading AMDVLK by default by moving the driver to $share/amdvlk/icd.d/
      amdvlk_noDefault = super.pkgs.symlinkJoin {
        name = "amdvlk_noDefault";
        paths = [ "${super.pkgs.amdvlk}/share/vulkan" ];
        postBuild = ''
          mkdir -p $out/share/amdvlk
          mv $out/icd.d $out/share/amdvlk
        '';
      };

      mpv_sponsorblock = super.pkgs.mpv.override {
        scripts = [
          (super.callPackage ./mpv-scripts/sponsorblock.nix { })
        ];
      };
    })
  ];
}
