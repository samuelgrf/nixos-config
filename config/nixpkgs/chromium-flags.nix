{ lib }:

let
  flags = lib.concatMapStrings (s: " --" + s);
  enableFeatures = l: " --enable-features=${__concatStringsSep "," l}";
  disableFeatures = l: " --disable-features=${__concatStringsSep "," l}";

in flags [

  # Ungoogled flags
  "disable-search-engine-collection"
  "extension-mime-request-handling=always-prompt-for-install"
  "popups-to-tabs"
  "remove-grab-handle"
  "remove-tabsearch-button"
  "show-avatar-button=incognito-and-guest"

  # Dark mode
  "force-dark-mode"

  # Wayland
  "ozone-platform-hint=auto"

  # Performance
  "enable-gpu-rasterization"
  "enable-zero-copy"

] + enableFeatures [
  "BackForwardCache:enable_same_site/true"
  "CanvasOopRasterization"
  "OverlayScrollbar"
  "RawDraw"
  "TabHoverCardImages"

] + disableFeatures [ "SharingHubDesktopOmnibox" "Vulkan" ]
