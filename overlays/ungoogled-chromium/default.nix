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
    ];
  };

}
