{ config, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {

      ##########################################################################
      ## Channel aliases
      ##########################################################################

      # Alias for unstable channel
      unstable = import <nixos-unstable> { config = config.nixpkgs.config; };

      # Unstable alias with overlays
      unstableFinal = import <nixos-unstable> {
        config = config.nixpkgs.config;
        overlays = config.nixpkgs.overlays;
      };


      ##########################################################################
      ## Packages
      ##########################################################################

      g810-led = prev.callPackage ./g810-led { };

      mangohud = prev.callPackage ./mangohud/combined.nix {
        libXNVCtrl = config.boot.kernelPackages.nvidia_x11.settings.libXNVCtrl;
      };

      mpv = prev.mpv.override {
        scripts = [
          final.mpv_sponsorblock
          (prev.callPackage ./mpv-scripts/youtube-quality.nix { })
        ];
      };

      # mpv_sponsorblock: Override some default options.
      mpv_sponsorblock = prev.mpvScripts.sponsorblock.overrideAttrs (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          substituteInPlace sponsorblock.lua \
            --replace 'skip_categories = "sponsor"' \
              'skip_categories = "sponsor,intro,interaction,selfpromo"' \
            --replace 'local_pattern = ""' \
              'local_pattern = "-([%w-_]+)%.[mw][kpe][v4b]m?$"'
        '';
      });

      nativeStdenv = prev.impureUseNativeOptimizations prev.stdenv;

      nerdfonts = prev.recurseIntoAttrs {
        hack = prev.nerdfonts.override { fonts = [ "Hack" ]; };
        meslo-lg = prev.nerdfonts.override { fonts = [ "Meslo" ]; };
      };

      # pcsx2: Enable native optimizations and build with GTK3.
      pcsx2 = (prev.callPackage ./pcsx2 {
        stdenv = final.nativeStdenv;
        wxGTK = prev.wxGTK30-gtk3;
      })
        .overrideAttrs (oldAttrs: {
          cmakeFlags = prev.lib.remove "-DDISABLE_ADVANCE_SIMD=TRUE"
            oldAttrs.cmakeFlags;
      });

      # steam: Add cabextract, needed for Protontricks to install MS core fonts.
      steam = prev.steam.override { extraPkgs = pkgs: [ prev.cabextract ]; };

      # winetricks: Use Wine staging with both 32-bit and 64-bit support.
      winetricks = prev.winetricks.override { wine = prev.wineWowPackages.staging; };

    })
  ];
}
