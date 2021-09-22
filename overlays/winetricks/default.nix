_: prev:
with prev; {

  winetricks = winetricks.override { wine = wineWowPackages.staging; };

}
