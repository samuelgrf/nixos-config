{ lib, ... }:

let
  flags = lib.concatMapStrings (s: " --" + s);
  enableFeatures = l: " --enable-features=${__concatStringsSep "," l}";
  disableFeatures = l: " --disable-features=${__concatStringsSep "," l}";
in {

  nixpkgs.config.chromium.commandLineArgs = flags [

    # Ungoogled
    "disable-search-engine-collection"
    "extension-mime-request-handling=always-prompt-for-install"
    "popups-to-tabs"
    "remove-grab-handle"
    "remove-tabsearch-button"
    "show-avatar-button=incognito-and-guest"

    # Dark mode
    "force-dark-mode"

    # Performance
    "enable-gpu-rasterization"
    "enable-oop-rasterization"
    "enable-zero-copy"
    "ignore-gpu-blocklist"

  ] + enableFeatures [
    "BackForwardCache:enable_same_site/true"
    "CanvasOopRasterization"
    "OverlayScrollbar"
    "TabHoverCardImages"
    "VaapiVideoDecoder"

  ] + disableFeatures [ "SettingsLandingPageRedesign" ];
}
