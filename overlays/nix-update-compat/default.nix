let
  inherit (import ../../flake-compat.nix) inputs;
  pkgs = import inputs.nixpkgs { };
in _:

import inputs.nixpkgs {
  config = import ../../config/shared/nixpkgs.nix { inherit pkgs; };
  overlays = __attrValues (import ../. { inherit (pkgs) lib; });
}
