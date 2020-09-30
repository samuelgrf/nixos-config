{ config, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {

      ##########################################################################
      ## Channel aliases
      ##########################################################################

      # Alias for unstable channel
      unstable = import <nixos-unstable> {
        config = config.nixpkgs.config;
        localSystem = config.nixpkgs.localSystem;
        crossSystem = config.nixpkgs.crossSystem;
      };

      # Unstable alias with overlays
      unstableFinal = import <nixos-unstable> {
        config = config.nixpkgs.config;
        overlays = config.nixpkgs.overlays;
        localSystem = config.nixpkgs.localSystem;
        crossSystem = config.nixpkgs.crossSystem;
      };


      ##########################################################################
      ## Packages
      ##########################################################################

      g810-led = prev.callPackage ./g810-led { };

      hack_nerdfont = prev.nerdfonts.override { fonts = [ "Hack" ]; };
      meslo-lg_nerdfont = prev.nerdfonts.override { fonts = [ "Meslo" ]; };

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

      # pcsx2: Enable native optimizations and workaround GTK2 errors on KDE Plasma.
      pcsx2 = (prev.pcsx2.override { stdenv = final.pkgsi686Linux.nativeStdenv; })

        .overrideAttrs (oldAttrs: {
          cmakeFlags = prev.lib.remove "-DDISABLE_ADVANCE_SIMD=TRUE"
            oldAttrs.cmakeFlags;

          postFixup = ''
            wrapProgram $out/bin/PCSX2 \
              --set __GL_THREADED_OPTIMIZATIONS 1 \
              --set GTK2_RC_FILES ""
          '';
      });

      sqlectron = prev.callPackage ./sqlectron { };

      # steam: Add cabextract, needed for Protontricks to install MS core fonts.
      steam = prev.steam.override { extraPkgs = pkgs: [ final.cabextract ]; };

      stevenblack-hosts-porn-extension = prev.callPackage ./hosts/stevenblack-porn-extension.nix { };

      # winetricks: Use Wine staging with both 32-bit and 64-bit support.
      winetricks = prev.winetricks.override { wine = final.wineWowPackages.staging; };

    })
  ];
}
