{ config, lib, ... }:

with lib; rec {

  mkWebstoreUrl = id:
    "javascript:location.href="
    + "'https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3'"
    + "+'&prodversion='+(navigator.appVersion.match(/Chrome\\/(\\S+)/)[1])"
    + "+'&x=id%'+'3D'+'${id}'+'%'+'26installsource%'+'3Dondemand%'+'26uc'";

  mkWebstoreBookmarks = exts:
    mapAttrsToList (n: id: { name = n; url = mkWebstoreUrl id; }) exts;

  pkgsImport = pkgs:
    import pkgs {
      config = config.nixpkgs.config;
      overlays = config.nixpkgs.overlays;
      system = config.nixpkgs.system;
    };

}
