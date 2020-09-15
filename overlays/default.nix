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

      g810-led = super.callPackage ./g810-led { };

      hack_nerdfont = super.nerdfonts.override { fonts = [ "Hack" ]; };
      meslo-lg_nerdfont = super.nerdfonts.override { fonts = [ "Meslo" ]; };

      manix = super.callPackage ./manix { };

      mpv = super.mpv.override {
        scripts = [
          self.mpv_sponsorblock
          (super.callPackage ./mpv-scripts/youtube-quality.nix { })
        ];
      };

      # mpv_sponsorblock: Override some default options.
      mpv_sponsorblock = super.mpvScripts.sponsorblock.overrideAttrs (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          substituteInPlace sponsorblock.lua \
            --replace 'skip_categories = "sponsor"' \
              'skip_categories = "sponsor,intro,interaction,selfpromo"' \
            --replace 'local_pattern = ""' \
              'local_pattern = "-([%w-_]+)%.[mw][kpe][v4b]m?$"'
        '';
      });

      nativeStdenv = super.impureUseNativeOptimizations super.stdenv;

      # pcsx2: Enable native optimizations and workaround GTK2 errors on KDE Plasma.
      pcsx2 = (super.pcsx2.override { stdenv = self.pkgsi686Linux.nativeStdenv; })

        .overrideAttrs (oldAttrs: {
          cmakeFlags = super.lib.remove "-DDISABLE_ADVANCE_SIMD=TRUE"
            oldAttrs.cmakeFlags;

          postFixup = ''
            wrapProgram $out/bin/PCSX2 \
              --set __GL_THREADED_OPTIMIZATIONS 1 \
              --set GTK2_RC_FILES ""
          '';
      });

      # steam: Add cabextract, needed for Protontricks to install MS core fonts.
      steam = super.steam.override { extraPkgs = pkgs: [ self.cabextract ]; };

      stevenblack-hosts-porn-extension = super.callPackage ./hosts/stevenblack-porn-extension.nix { };

      # winetricks: Use Wine staging with both 32-bit and 64-bit support.
      winetricks = super.winetricks.override { wine = self.wineWowPackages.staging; };

    })
  ];
}
