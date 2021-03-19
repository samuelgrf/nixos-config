_: prev:

with prev; {

  linuxPackages_zen = linuxPackages_zen // {

    hid-playstation = callPackage ./hid-playstation {
      inherit (linuxPackages_zen) kernel stdenv;
    };

    rtw88 = callPackage ./rtw88 { inherit (linuxPackages_zen) kernel stdenv; };
    rtw88-firmware = callPackage ./rtw88/firmware.nix { };
  };

}
