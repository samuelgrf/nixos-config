[

  # gimpPlugins.bimp: Init
  (import ./gimpPlugins)

  # linuxKernel.kernels.linux_zen:
  (import ./linux_zen/config.nix) # Customize kernel configuration.
  (import ./linux_zen/source.nix) # Ensure ZFS compatibility.

  # linuxLTOPackages*: Build LinuxPackages* with LLVM and LTO.
  # Thanks a lot to @lovesegfault for his work on this!
  # Based on: https://github.com/lovesegfault/nix-config/blob/7ddb02fa8c52b2422c4b74e385ab511a71a6f5e6/nix/overlays/linux-lto.nix
  (import ./linuxLTOPackages)

  # pdfsizeopt: Init
  (import ./pdfsizeopt)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

  # winetricks: Use Wine with 64-bit support.
  (import ./winetricks)

]
