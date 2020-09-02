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

      # google-chrome-beta: Update to newest version.
      google-chrome-beta = super.google-chrome-beta.overrideAttrs (oldAttrs: rec {
        name = "google-chrome-beta";
        version = "86.0.4240.22";

        src = super.fetchurl {
          url = "https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-beta/google-chrome-beta_${version}-1_amd64.deb";
          sha256 = "05qdzkq9daqjliqj7zxsa03903rv3kwaj627192ls6m33bacz9gp";
        };
      });

      g810-led = super.callPackage ./g810-led { };

      hack_nerdfont = super.nerdfonts.override { fonts = [ "Hack" ]; };
      meslo-lg_nerdfont = super.nerdfonts.override { fonts = [ "Meslo" ]; };

      kwin-dynamic-workspaces =
        super.libsForQt5.callPackage ./kwin-scripts/dynamic-workspaces.nix { };

      mpv = super.mpv.override {
        scripts = [
          self.mpv_sponsorblock
          (super.callPackage ./mpv-scripts/youtube-quality.nix { })
        ];
      };

      # Override some mpv_sponsorblock default options.
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

      # Enable native optimizations and workaround GTK2 errors on KDE Plasma.
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

      # Protonfixes requires cabextract to install MS core fonts.
      steam = super.steam.override { extraPkgs = pkgs: [ self.cabextract ]; };

    })
  ];
}
