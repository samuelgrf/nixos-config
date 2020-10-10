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
      ## Files from Nixpkgs PRs
      ##########################################################################

      prFiles = let
        rawUrl = "https://raw.githubusercontent.com/NixOS/nixpkgs";
      in prev.recurseIntoAttrs {

        # https://github.com/NixOS/nixpkgs/pull/92119
        g810-led = prev.fetchurl {
          url = "${rawUrl}/e87909644e473c54db1a2208043fd2d60591970f/pkgs/misc/g810-led/default.nix";
          sha256 = "1rqbzri87cg71s3b0wb3b211alyh425xp35r9hv0z1zs8p73q3nm";
        };

        # https://github.com/NixOS/nixpkgs/pull/95225
        mangohud = prev.fetchFromGitHub {
          owner = "NixOS";
          repo = "nixpkgs";
          rev = "9e2cfa716a95cfc79a580d91254a0805b38e23ba";
          sha256 = "1xpvmvfamq3m990c64hh6iy4cjky1sb0dh1iz8lmzsh7l28pkl9s";
        };

        # https://github.com/NixOS/nixpkgs/pull/100162
        pcsx2 = prev.fetchurl {
          url = "${rawUrl}/2ce48d2ee79c7fdd22192f7a29b897f1526ea7a3/pkgs/misc/emulators/pcsx2/default.nix";
          sha256 = "04fq9l1c5v11iyaskx73mymmzxhgjmgcl64b6iqncaih9hw0qff0";
        };

        # https://github.com/NixOS/nixpkgs/pull/96983
        youtube-quality = prev.fetchurl {
          url = "${rawUrl}/b7a340126ccd352c1f650fdd0ceb966c38d4b800/pkgs/applications/video/mpv/scripts/youtube-quality.nix";
          sha256 = "0vq9d3krfxlq8gbj1pfpb6j0d24mqgp1gfsvq20h4bq10p89pkfl";
        };
      };


      ##########################################################################
      ## Packages
      ##########################################################################

      g810-led = prev.callPackage final.prFiles.g810-led { };

      mangohud = prev.callPackage
        "${final.prFiles.mangohud}/pkgs/tools/graphics/mangohud/combined.nix" {
          libXNVCtrl = config.boot.kernelPackages.nvidia_x11.settings.libXNVCtrl;
        };

      mpv = prev.mpv.override {
        scripts = [
          final.mpv_sponsorblock
          (prev.callPackage final.prFiles.youtube-quality { })
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
      pcsx2 = (prev.callPackage final.prFiles.pcsx2 {
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
