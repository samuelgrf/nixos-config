flakes:
with flakes;

flake-utils.lib.eachDefaultSystem (system: rec {

  checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
    src = ./.;
    hooks = {
      nixfmt = {
        enable = true;
        excludes =
          [ "machines/.*/hardware-generated.nix" "overlays/default.nix" ];
      };
      nix-linter = {
        enable = true;
        excludes =
          [ "machines/.*/hardware-generated.nix" "overlays/default.nix" ];
      };
    };
    settings.nix-linter.checks =
      [ "BetaReduction" "EmptyVariadicParamSet" "UnneededAntiquote" ];
  };

  devShell = self.legacyPackages.${system}.mkShell {
    shellHook = checks.pre-commit-check.shellHook + ''
      if [ -L .pre-commit-config.yaml ]; then >/dev/null \
        nix-store \
          --add-root .pre-commit-config.yaml \
          -r .pre-commit-config.yaml
      fi
    '';
  };

})
