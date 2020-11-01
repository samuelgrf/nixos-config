{ config, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {

      # chromium: Add command line arguments.
      chromium = prev.chromium.override {
        commandLineArgs = "--ignore-gpu-blocklist --enable-gpu-rasterization \\
          --enable-oop-rasterization --enable-zero-copy \\
          --force-dark-mode --enable-features=WebUIDarkMode"

            # TODO Remove `--force-device-scale-factor=1` when
            # https://bugs.chromium.org/p/chromium/issues/detail?id=1087109
            # or https://github.com/NixOS/nixpkgs/issues/89512
            # is resolved.
            + (prev.lib.optionalString (config.networking.hostName == "HPx")
              " --enable-accelerated-video-decode --force-device-scale-factor=1");
      };

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

      # nix-zsh-completions: Add experimental flake support.
      nix-zsh-completions = prev.nix-zsh-completions.overrideAttrs (oldAttrs: {
        src = prev.fetchFromGitHub {
          owner = "Ma27";
          repo = "nix-zsh-completions";
          rev = "939c48c182e9d018eaea902b1ee9d00a415dba86";
          hash = "sha256-3HVYez/wt7EP8+TlhTppm968Wl8x5dXuGU0P+8xNDpo=";
        };
      });

      # pcsx2: Enable native optimizations.
      pcsx2 = (prev.pcsx2.override {
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
