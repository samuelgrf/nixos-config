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

      hack_nerdfont = super.nerdfonts.override { fonts = [ "Hack" ]; };
      meslo-lg_nerdfont = super.nerdfonts.override { fonts = [ "Meslo" ]; };

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

      # Use 64-bit fork, workaround GTK2 errors on KDE Plasma and enable
      # native optimizations.
      pcsx2 = super.callPackage ./pcsx2 {
        stdenv = self.nativeStdenv;
        wxGTK = self.wxGTK30;
      };

      # Needed for the rtl8821ce module to work on kernel v5.7.10+.
      rtl8821ce = super.rtl8821ce.overrideAttrs (oldAttrs: {
        src = super.fetchFromGitHub {
          owner = "tomaspinho";
          repo = "rtl8821ce";
          rev = "8d7edbe6a78fd79cfab85d599dad9dc34138abd1";
          sha256 = "1hsf8lqjnkrkvk0gps8yb3lx72mvws6xbgkbdmgdkz7qdxmha8bp";
        };
      });

      # stdenv with native optimizations enabled.
      nativeStdenv = super.impureUseNativeOptimizations super.stdenv;

      # Protonfixes requires cabextract to install MS core fonts.
      steam = super.steam.override { extraPkgs = pkgs: [ self.cabextract ]; };

    })
  ];
}
