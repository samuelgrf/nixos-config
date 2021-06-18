[

  # gimpPlugins.bimp: Init
  (import ./gimpPlugins)

  # TODO Remove once https://github.com/NixOS/nixpkgs/pull/123720 is merged.
  # nixos-rebuild: Fix creating ./result symlink for flakes.
  (import ./nixos-rebuild)

  # pdfsizeopt: Init
  (import ./pdfsizeopt)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

]
