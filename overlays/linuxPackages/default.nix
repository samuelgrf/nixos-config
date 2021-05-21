_: prev:
with prev; {

  linuxPackagesFor = kernel:
    (linuxPackagesFor kernel).extend (_: _: { ati_drivers_x11 = null; });

}
