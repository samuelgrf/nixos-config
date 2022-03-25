{ lib }:

lib.genAttrs [

  "calibre" # Fix decryption via DeDRM plugin.

  "Ωexe" # Add `exe` attribute to packages.

  "gimpPlugins" # Add bimp

  "hydra-check" # Support checking `tested` job.

  "Ωlinux-lto" # Build Linux packages with LLVM and LTO.

  "linux_zen/config.nix" # Customize kernel configuration.
  "linux_zen/source.nix" # Ensure ZFS compatibility.

  "nix-index-database" # Init

  "pdfsizeopt" # Init

  "wine-lutris" # Init

  "yt-dlp" # Update

] (path: import (./. + "/${__replaceStrings [ "Ω" ] [ "" ] path}"))
