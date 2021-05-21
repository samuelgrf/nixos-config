{ flakes }: [

  # TODO Remove on 21.05.
  # kdeGear: Alias for packages related to KDE.
  (_: prev: { kdeGear = prev.kdeApplications // prev.libsForQt5; })

  # TODO Remove on 21.05.
  # libstrangle: Get from nixpkgs unstable.
  (import ./libstrangle { inherit (flakes) nixpkgs-unstable; })

  # linuxPackages*.ati_drivers_x11: Fix build failure caused by throw.
  # TODO Remove when https://github.com/NixOS/nixpkgs/issues/123972 is fixed.
  (import ./linuxPackages)

  # linux_zen: Update to 5.12.2-zen2.
  (import ./linux_zen)

  # plasma5.kwin: Apply low latency patch.
  (import ./kwin)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

]
