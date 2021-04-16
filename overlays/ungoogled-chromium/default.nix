{ config }:

_: prev:
with prev; {

  ungoogled-chromium = ungoogled-chromium.override {
    commandLineArgs = toString [

      # Ungoogled flags
      "--disable-search-engine-collection"
      "--extension-mime-request-handling=always-prompt-for-install"
      "--popups-to-tabs"
      "--show-avatar-button=incognito-and-guest"

      # Experimental features
      ("--enable-features=TabSearch"
        + lib.optionalString (config.networking.hostName == "amethyst")
        ",VaapiVideoDecoder")

      # Dark mode
      "--force-dark-mode"

      # Performance
      "--enable-gpu-rasterization"
      "--enable-oop-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"

    ]
    # TODO Remove after
    # https://bugs.chromium.org/p/chromium/issues/detail?id=1087109 &
    # https://github.com/NixOS/nixpkgs/issues/89512
    # are resolved.
      + lib.optionalString (config.networking.hostName == "amethyst")
      " --force-device-scale-factor=1";
  };

}
