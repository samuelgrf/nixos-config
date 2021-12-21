{ lib }:

lib.genAttrs [

  "gimpPlugins" # Add bimp

  "hydra-check" # Support checking `tested` job.

  "linux_zen/config.nix" # Customize kernel configuration.
  "linux_zen/source.nix" # Ensure ZFS compatibility.

  # Thanks a lot to @lovesegfault for his work on this!
  # Based on: https://github.com/lovesegfault/nix-config/blob/1f871d87ae432bb47557a8fa0ae22f626377c70f/nix/overlays/linux-lto.nix
  "linuxPackages_lto" # Build LinuxPackages* with LLVM and LTO.

  "nix-index-database" # Init

  "pdfsizeopt" # Init

] (file: final: prev: import (./. + "/${file}") final prev)
