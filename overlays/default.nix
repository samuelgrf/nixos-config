{ flakes }:

final: prev: {

  # ungoogled-chromium: Add command line arguments.
  ungoogled-chromium = prev.ungoogled-chromium.override {
    commandLineArgs = toString [
      # Performance
      "--enable-gpu-rasterization"
      "--enable-oop-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"

      # Dark Mode
      "--enable-features=WebUIDarkMode"
      "--force-dark-mode"

      # Misc
      "--disable-search-engine-collection"
      "--enable-features=TabSearch"
      "--extension-mime-request-handling=always-prompt-for-install"
      "--popups-to-tabs"
      "--show-avatar-button=incognito-and-guest"

      # TODO Remove `--force-device-scale-factor=1` when
      # https://bugs.chromium.org/p/chromium/issues/detail?id=1087109
      # or https://github.com/NixOS/nixpkgs/issues/89512
      # is resolved.
      "$([ $HOSTNAME = HPx ] && printf %s '${
        toString [
          "--enable-accelerated-video-decode"
          "--force-device-scale-factor=1"
        ]
      }')"
    ];
  };

  # kwin: Apply low latency patch
  # Patch files can be found here: https://tildearrow.org/storage/kwin-lowlatency
  plasma5 = prev.plasma5 // {
    kwin = prev.plasma5.kwin.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [
        (prev.fetchpatch {
          url =
            "https://tildearrow.org/storage/kwin-lowlatency/kwin-lowlatency-5.18.5-3.patch";
          sha256 = "sha256-HaHw7CDayhtlTA8qs8maUsz4qjHTVUsYaFg9IFxjGhM=";
        })
      ];
    });
  };

  amdvlkUnstable = prev.callPackage
    "${flakes.nixpkgs-unstable}/pkgs/development/libraries/amdvlk" { };

  mesaUnstable = with prev;
    callPackage "${flakes.nixpkgs-unstable}/pkgs/development/libraries/mesa" {
      llvmPackages = llvmPackages_latest;
      inherit (darwin.apple_sdk.frameworks) OpenGL;
      inherit (darwin.apple_sdk.libs) Xplugin;
    };

  # TODO Remove on 21.05.
  # linux_zen: Add HID driver for the PS5 DualSense controller
  linuxPackages_zen = with prev;
    linuxPackages_zen // {
      hid-playstation = callPackage ./hid-playstation {
        inherit (linuxPackages_zen) kernel stdenv;
      };
    };

  g810-led = prev.callPackage ./g810-led { };

  libstrangle = prev.callPackage ./libstrangle { stdenv = prev.stdenv_32bit; };

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

  # nix-zsh-completions: Add experimental flake support.
  nix-zsh-completions = prev.nix-zsh-completions.overrideAttrs (_: {
    src = prev.fetchFromGitHub {
      owner = "Ma27";
      repo = "nix-zsh-completions";
      rev = "939c48c182e9d018eaea902b1ee9d00a415dba86";
      hash = "sha256-3HVYez/wt7EP8+TlhTppm968Wl8x5dXuGU0P+8xNDpo=";
    };
  });

  # pcsx2: Enable native optimizations.
  pcsx2 = (prev.pcsx2.override { stdenv = final.nativeStdenv; }).overrideAttrs
    (oldAttrs: {
      cmakeFlags =
        prev.lib.remove "-DDISABLE_ADVANCE_SIMD=TRUE" oldAttrs.cmakeFlags;
    });

  # steam: Add cabextract, needed for Protontricks to install MS core fonts.
  steam = prev.steam.override { extraPkgs = _: [ prev.cabextract ]; };

  # winetricks: Use Wine staging with both 32-bit and 64-bit support.
  winetricks =
    prev.winetricks.override { wine = prev.wineWowPackages.staging; };

}
