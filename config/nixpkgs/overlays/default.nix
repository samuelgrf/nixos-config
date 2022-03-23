{ lib }:

lib.genAttrs [

  "calibre" # Fix decryption via DeDRM plugin.

  "gimpPlugins" # Add bimp

  "hydra-check" # Support checking `tested` job.

  "linux_zen/config.nix" # Customize kernel configuration.
  "linux_zen/source.nix" # Ensure ZFS compatibility.

  # Thanks a lot to @lovesegfault for his work on this!
  # Based on: https://github.com/lovesegfault/nix-config/blob/a589f668eb2468694bff86607b66c8a60eaef893/nix/overlays/linux-lto.nix
  "linux_zen_lto" # Build `linux_zen` with LLVM and LTO.

  "nix-index-database" # Init

  "pdfsizeopt" # Init

  "winePackages_lutris" # Init

  "yt-dlp" # Update

  "z_exe" # Add `exe` attribute to packages.

] (file: final: prev: import (./. + "/${file}") final prev)
