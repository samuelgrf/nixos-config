_: prev:
with prev; {

  ungoogled-chromium = let
    argsOverride = ungoogled-chromium.passthru.argsOverride or { } // {
      commandLineArgs = toString [

        # Ungoogled flags
        "--disable-search-engine-collection"
        "--extension-mime-request-handling=always-prompt-for-install"
        "--hide-tab-close-buttons"
        "--popups-to-tabs"
        "--remove-grab-handle"
        "--remove-tabsearch-button"
        "--show-avatar-button=incognito-and-guest"

        # Experimental features
        "--enable-features=${
          lib.concatStringsSep "," [
            "BackForwardCache:enable_same_site/true"
            "CanvasOopRasterization"
            "OverlayScrollbar"
            "RawDraw"
            "TabHoverCardImages"
            "VaapiVideoDecoder"
          ]
        }"

        # Revert settings page redesign
        "--disable-features=SettingsLandingPageRedesign"

        # Dark mode
        "--force-dark-mode"

        # Performance
        "--enable-gpu-rasterization"
        "--enable-oop-rasterization"
        "--enable-zero-copy"
        "--ignore-gpu-blocklist"
      ];
    };

  in ungoogled-chromium.override argsOverride // {
    passthru = { inherit argsOverride; };
  };
}
