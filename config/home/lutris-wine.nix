{ lib, pkgs, ... }:

let
  mkPath = p:
    ".local/share/lutris/runners/wine/lutris-fshack-${p.version}-x86_64";
in {

  home.file = with lib;
    mapAttrs' (_: source: nameValuePair (mkPath source) { inherit source; })
    pkgs.winePackages_lutris;
}
