{ nixpkgs-unstable }: [

  # gimpPlugins.bimp: Init
  (import ./gimpPlugins)

  # TODO Remove once https://github.com/NixOS/nixpkgs/pull/129227 is backported.
  # kjv: 2018-12-25 -> 2021-03-11
  (import ./kjv)

  # linux_zen: Customize configuration & build with latest GCC.
  (import ./linux_zen)

  # TODO Remove once https://github.com/NixOS/nixpkgs/pull/126960 is merged.
  # nixos-rebuild: Fix creating ./result symlink for flakes.
  (import ./nixos-rebuild { inherit nixpkgs-unstable; })

  # pdfsizeopt: Init
  (import ./pdfsizeopt)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

]
