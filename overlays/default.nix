{ flakes }: [

  # TODO Remove on 21.05.
  # libstrangle: Get from nixpkgs unstable.
  (import ./libstrangle { inherit (flakes) nixpkgs-unstable; })

  # linux_zen: Update to 5.12.2-zen2.
  (import ./linux_zen)

  # plasma5.kwin: Apply low latency patch.
  (import ./kwin)

  # TODO Remove on 21.05.
  # kdeGear: Alias for packages related to KDE.
  (_: prev: { kdeGear = prev.kdeApplications // prev.libsForQt5; })

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

]
