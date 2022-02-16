{ pkgs, ... }:

with pkgs.lib; {

  # Select allowed unfree packages.
  allowUnfreePredicate = pkg:
    elem (getName pkg) [
      "chrome-widevine-cdm"
      "chromium-unwrapped"
      "mpv-youtube-quality"
      "steam"
      "steam-original"
      "steam-runtime"
      "ungoogled-chromium"
      "unrar"
    ];

  # Disallow package aliases.
  allowAliases = false;

  # Add flags to Chromium packages.
  chromium.commandLineArgs =
    import ./chromium-flags.nix { inherit (pkgs) lib; };
}
