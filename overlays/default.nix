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
      ## Packages
      ##########################################################################

      # The Vulkan Loader tries to load the default driver from "$share/vulkan/icd.d/",
      # prevent loading AMDVLK by default by moving the driver to "$share/amdvlk/icd.d/".
      amdvlk_noDefault = super.symlinkJoin {
        name = "amdvlk_noDefault";
        paths = [ "${self.amdvlk}/share/vulkan" ];
        postBuild = ''
          mkdir -p $out/share/amdvlk
          mv $out/icd.d $out/share/amdvlk
        '';
      };

      g810-led = super.callPackage ./g810-led { };

      hack_nerdfont = super.nerdfonts.override { fonts = [ "Hack" ]; };
      meslo-lg_nerdfont = super.nerdfonts.override { fonts = [ "Meslo" ]; };

      mpv = super.mpv.override {
        scripts = [
          (super.callPackage ./mpv-scripts/sponsorblock.nix { })
          (super.callPackage ./mpv-scripts/youtube-quality.nix { })
        ];
      };

      # Protonfixes requires cabextract to install MS core fonts.
      steam = super.steam.override { extraPkgs = pkgs: [ self.cabextract ]; };

    })
  ];
}
