{ flake-utils, pre-commit-hooks, self, ... }:
with self;

flake-utils.lib.eachDefaultSystem (system: {

  checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
    src = ./.;
    hooks = {
      nixfmt = {
        enable = true;
        excludes = [ "config/machines/.*/nixos-generated.nix" ];
      };
      nix-linter = {
        enable = true;
        excludes =
          [ "config/machines/.*/nixos-generated.nix" "overlays/default.nix" ];
      };
    };
    settings.nix-linter.checks =
      [ "BetaReduction" "EmptyVariadicParamSet" "UnneededAntiquote" ];
  };

  devShell = legacyPackages.${system}.mkShell {
    shellHook = checks.${system}.pre-commit-check.shellHook + ''
      if [ -L .pre-commit-config.yaml ]; then >/dev/null \
        nix-store \
          --add-root .pre-commit-config.yaml \
          -r .pre-commit-config.yaml
      fi
    '';
  };
})
