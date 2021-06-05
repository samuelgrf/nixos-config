[

  # gimpPlugins.bimp: Init
  (import ./gimpPlugins)

  # TODO Remove once `nixUnstable` is updated in nixpkgs.
  # nix: Install Zsh completion script.
  (import ./nix)

  # TODO Remove once https://github.com/NixOS/nixpkgs/pull/123720 is merged.
  # nixos-rebuild: Fix creating ./result symlink for flakes.
  (import ./nixos-rebuild)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

]
