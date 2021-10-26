{ lib }:

lib.genAttrs [

  "gimpPlugins/bimp.nix" # Init

  "linux_zen/config.nix" # Customize kernel configuration.
  "linux_zen/source.nix" # Ensure ZFS compatibility.

  # Thanks a lot to @lovesegfault for his work on this!
  # Based on: https://github.com/lovesegfault/nix-config/blob/7ddb02fa8c52b2422c4b74e385ab511a71a6f5e6/nix/overlays/linux-lto.nix
  "linuxLTOPackages" # Build LinuxPackages* with LLVM and LTO.

  "nix-index-database" # Init

  "pdfsizeopt" # Init

  "ungoogled-chromium" # Add command line arguments.

] (file: final: prev: import (./. + "/${file}") final prev)
