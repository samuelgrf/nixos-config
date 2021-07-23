{ nixpkgs-unstable }: [

  # gimpPlugins.bimp: Init
  (import ./gimpPlugins)

  # TODO Remove once https://github.com/NixOS/nixpkgs/pull/129227 is backported.
  # kjv: 2018-12-25 -> 2021-03-11
  (import ./kjv)

  # linux_zen: Customize kernel configuration.
  (import ./linux_zen)

  # linuxLTOPackages*: Build LinuxPackages* with LLVM and LTO.
  # Thanks a lot to @lovesegfault for his work on this!
  # Based on: https://github.com/lovesegfault/nix-config/blob/34fa3f2a0588d03d3882c23e2ddcba202f07652f/nix/overlays/linux-lto.nix
  (import ./linuxLTOPackages)

  # TODO Remove once https://github.com/NixOS/nixpkgs/pull/126960 is merged.
  # nixos-rebuild: Fix creating ./result symlink for flakes.
  (import ./nixos-rebuild { inherit nixpkgs-unstable; })

  # pdfsizeopt: Init
  (import ./pdfsizeopt)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

]
