_: prev:
with prev; {

  linuxPackages_zen = let
    callPackage =
      newScope (pkgs // { inherit (linuxPackages_zen) kernel stdenv; });
  in linuxPackages_zen // {

    hid-playstation = callPackage ./hid-playstation { };

  };

}
