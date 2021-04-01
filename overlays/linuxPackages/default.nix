_: prev:
with prev; {

  linuxPackagesFor = kernel:
    (linuxPackagesFor kernel).extend (_: lPrev:
      with lPrev; {

        hid-playstation = callPackage ./hid-playstation { };

      });

}
