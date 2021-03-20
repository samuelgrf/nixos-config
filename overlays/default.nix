{ flakes }: [

  # TODO Remove on 21.05.
  # libstrangle: Get from nixpkgs unstable.
  (import ./libstrangle { inherit (flakes) nixpkgs-unstable; })

  # TODO Remove on 21.05.
  # linuxPackages*.hid-playstation: Init
  (import ./linuxPackages)

  # mpv: Add playlistmanager script.
  (import ./mpv)

  # plasma5.kwin: Apply low latency patch.
  (import ./kwin)

  # TODO Remove on 21.05.
  # plasma5Packages: Alias for packages related to Plasma 5.
  (_: prev: { plasma5Packages = prev.kdeApplications // prev.libsForQt5; })

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

]
