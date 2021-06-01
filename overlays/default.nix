[

  # linux_zen: Update to 5.12.6-zen1.
  (import ./linux_zen)

  # TODO Remove once https://github.com/NixOS/nixpkgs/pull/123720 is merged.
  # nixos-rebuild: Fix creating ./result symlink for flakes.
  (import ./nixos-rebuild)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

]
