[

  # gimpPlugins.bimp: Init
  (import ./gimpPlugins)

  # linux_zen: Customize kernel configuration & fetch ZFS compatible release.
  (import ./linux_zen)

  # linuxLTOPackages*: Build LinuxPackages* with LLVM and LTO.
  # Thanks a lot to @lovesegfault for his work on this!
  # Based on: https://github.com/lovesegfault/nix-config/blob/7ddb02fa8c52b2422c4b74e385ab511a71a6f5e6/nix/overlays/linux-lto.nix
  (import ./linuxLTOPackages)

  # pdfsizeopt: Init
  (import ./pdfsizeopt)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

]
