[

  # gimpPlugins.bimp: Init
  (import ./gimpPlugins)

  # linux_zen: Customize kernel configuration & fetch ZFS compatible release.
  (import ./linux_zen)

  # linuxLTOPackages*: Build LinuxPackages* with LLVM and LTO.
  # Thanks a lot to @lovesegfault for his work on this!
  # Based on: https://github.com/lovesegfault/nix-config/blob/95326f665687c8400b0f76d6ccbc22a11490c7ed/nix/overlays/linux-lto.nix
  (import ./linuxLTOPackages)

  # pdfsizeopt: Init
  (import ./pdfsizeopt)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

]
