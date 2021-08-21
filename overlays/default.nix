[

  # gimpPlugins.bimp: Init
  (import ./gimpPlugins)

  # linux_zen: Customize kernel configuration.
  (import ./linux_zen)

  # linuxLTOPackages*: Build LinuxPackages* with LLVM and LTO.
  # Thanks a lot to @lovesegfault for his work on this!
  # Based on: https://github.com/lovesegfault/nix-config/blob/34fa3f2a0588d03d3882c23e2ddcba202f07652f/nix/overlays/linux-lto.nix
  (import ./linuxLTOPackages)

  # pdfsizeopt: Init
  (import ./pdfsizeopt)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

]
