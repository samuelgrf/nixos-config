{ nixpkgs-unstable }: [

  # gimpPlugins.bimp: Init
  (import ./gimpPlugins)

  # TODO Remove once https://github.com/NixOS/nixpkgs/pull/126960 is merged.
  # nixos-rebuild: Fix creating ./result symlink for flakes.
  (import ./nixos-rebuild { inherit nixpkgs-unstable; })

  # pdfsizeopt: Init
  (import ./pdfsizeopt)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

]
