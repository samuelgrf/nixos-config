let
  inherit (import ../..) inputs;
  pkgs = import inputs.nixpkgs { };
in _:

import inputs.nixpkgs {
  config = import ../../main/nixpkgs.nix { inherit pkgs; };
  overlays = __attrValues (import ../../overlays { inherit (pkgs) lib; });
}
