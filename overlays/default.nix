{ config, ... }:

{
  nixpkgs.overlays = [
    (self: super: {

      ##########################################################################
      ## Channel aliases
      ##########################################################################

      # Alias for unstable channel.
      unstable = import <nixos-unstable> {
        config = config.nixpkgs.config;
        overlays = config.nixpkgs.overlays;
        localSystem = config.nixpkgs.localSystem;
        crossSystem = config.nixpkgs.crossSystem;
      };

      # Unstable alias without overlays.
      # Can be used inside overlays without causing infinite recursions.
      unstableSuper = import <nixos-unstable> {
        config = config.nixpkgs.config;
        overlays = [ ];
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

      # TODO Remove once https://github.com/NixOS/nixpkgs/pull/95389 is merged.
      google-chrome-beta = super.callPackage ./google-chrome {
        channel = "beta";
        chromium = self.chromiumBeta;
        gconf = self.gnome2.GConf;
      };

      hack_nerdfont = super.nerdfonts.override { fonts = [ "Hack" ]; };
      meslo-lg_nerdfont = super.nerdfonts.override { fonts = [ "Meslo" ]; };

      # Use unstable channel because of script support, this is done in an
      # overlay to make sure Home Manager and NixOS use the same derivation.
      mpv = self.unstableSuper.mpv.override {
        scripts = [
          (self.mpv_sponsorblock)
          (super.callPackage ./mpv-scripts/youtube-quality.nix { })
        ];
      };

      # Override some mpv_sponsorblock default options.
      mpv_sponsorblock = (super.callPackage ./mpv-scripts/sponsorblock.nix { }).
        overrideAttrs (oldAttrs: {
          postPatch = (oldAttrs.postPatch or "") + ''
            substituteInPlace sponsorblock.lua \
              --replace 'skip_categories = "sponsor"' \
                'skip_categories = "sponsor,intro,interaction,selfpromo"' \
              --replace 'local_pattern = ""' \
                'local_pattern = "-([%w-_]+)%.[mw][kpe][v4b]m?$"'
          '';
        });

      nativeStdenv = super.impureUseNativeOptimizations super.stdenv;

      # Workaround GTK2 errors on KDE Plasma and enable native optimizations.
      pcsx2 = super.callPackage_i686 ./pcsx2 {
        stdenv = self.pkgsi686Linux.nativeStdenv;
        wxGTK = self.pkgsi686Linux.wxGTK30;
      };

      # Protonfixes requires cabextract to install MS core fonts.
      steam = super.steam.override { extraPkgs = pkgs: [ self.cabextract ]; };

    })
  ];
}
