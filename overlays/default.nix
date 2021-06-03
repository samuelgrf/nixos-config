[

  # TODO Remove once https://github.com/NixOS/nixpkgs/pull/123720 is merged.
  # nixos-rebuild: Fix creating ./result symlink for flakes.
  (import ./nixos-rebuild)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

]
