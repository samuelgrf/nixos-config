{ lib }:

lib.genAttrs [

  "exe" # Add exe attribute to packages.

  "gimpPlugins" # Add bimp

  "hydra-check" # Support checking `tested` job.

  "linux_zen/config.nix" # Customize kernel configuration.
  "linux_zen/source.nix" # Ensure ZFS compatibility.

  # Thanks a lot to @lovesegfault for his work on this!
  # Based on: https://github.com/lovesegfault/nix-config/blob/e073916846af1faaa15923cd88894f927a6f40e2/nix/overlays/linux-lto.nix
  "linux_zen_lto" # Build `linux_zen` with LLVM and LTO.

  "nix-index-database" # Init

  "pdfsizeopt" # Init

  "skanpage" # Init

] (file: final: prev: import (./. + "/${file}") final prev)
