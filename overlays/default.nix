{ lib }:

lib.genAttrs [

  "gimpPlugins" # Add bimp

  "hydra-check" # Support checking `tested` job.

  "linux_zen/config.nix" # Customize kernel configuration.
  "linux_zen/source.nix" # Ensure ZFS compatibility.

  # Thanks a lot to @lovesegfault for his work on this!
  # Based on: https://github.com/lovesegfault/nix-config/blob/0dec3c694c25d5e74485e3a8f508e87a1b3fc899/nix/overlays/linux-lto.nix
  "linux_zen_lto" # Build `linux_zen` with LLVM and LTO.

  "nix-index-database" # Init

  "pdfsizeopt" # Init

] (file: final: prev: import (./. + "/${file}") final prev)
