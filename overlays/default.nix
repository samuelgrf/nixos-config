{ flakes }: [

  # TODO Remove on 21.05.
  # libstrangle: Get from nixpkgs unstable.
  (import ./libstrangle { inherit (flakes) nixpkgs-unstable; })

  # TODO Remove on 21.05.
  # linuxPackages_zen: Add kernel modules (hid-playstation & rtw88).
  (import ./linuxPackages_zen)

  # plasma5.kwin: Apply low latency patch.
  (import ./kwin)

  # TODO Remove on 21.05.
  # plasma5Packages: Alias for packages related to Plasma 5.
  (import ./plasma5Packages)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

  # winetricks: Use wine staging with both 32-bit and 64-bit support.
  (import ./winetricks)

]
