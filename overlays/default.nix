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

      # TODO Remove once https://github.com/NixOS/nixpkgs/pull/95389 is merged.
      google-chrome-beta = super.callPackage ./google-chrome {
        channel = "beta";
        chromium = self.chromiumBeta;
        gconf = self.gnome2.GConf;
      };

      hack_nerdfont = super.nerdfonts.override { fonts = [ "Hack" ]; };
      meslo-lg_nerdfont = super.nerdfonts.override { fonts = [ "Meslo" ]; };

      # TODO Remove on 20.09.
      linux_zen = super.callPackage ./kernels/linux-zen.nix {
        kernelPatches = [
          self.kernelPatches.bridge_stp_helper
          self.kernelPatches.request_key_helper
          self.kernelPatches.export_kernel_fpu_functions."5.3"
        ];
      };

      linuxPackages_zen = super.recurseIntoAttrs (super.linuxPackagesFor self.linux_zen);

      # Use unstable channel because of script support, this is done in an
      # overlay to make sure Home Manager and NixOS use the same derivation.
      # TODO Remove "unstableSuper" on 20.09.
      mpv = self.unstableSuper.mpv.override {
        scripts = [
          self.mpv_sponsorblock
          (super.callPackage ./mpv-scripts/youtube-quality.nix { })
        ];
      };

      # Override some mpv_sponsorblock default options.
      # TODO Remove "unstableSuper" on 20.09.
      mpv_sponsorblock = self.unstableSuper.mpvScripts.sponsorblock.overrideAttrs (oldAttrs: {
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
