{ lib }:

lib.genAttrs [

  "gimpPlugins" # Add bimp

  "linux_zen/config.nix" # Customize kernel configuration.
  "linux_zen/source.nix" # Ensure ZFS compatibility.

  # Thanks a lot to @lovesegfault for his work on this!
  # Based on: https://github.com/lovesegfault/nix-config/blob/9abd6a2075831b2a40a859fd9663bad0656ed52c/nix/overlays/linux-lto.nix
  "linuxLTOPackages" # Build LinuxPackages* with LLVM and LTO.

  "nix-index-database" # Init

  "pdfsizeopt" # Init

  "spacemacs" # Init

  "ungoogled-chromium" # Add command line arguments.

] (file: final: prev: import (./. + "/${file}") final prev)
