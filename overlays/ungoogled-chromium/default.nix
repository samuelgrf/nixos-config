_: prev: {

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

}
