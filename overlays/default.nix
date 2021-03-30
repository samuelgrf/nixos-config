{ flakes }: [

  # amdvlkUnstable: Alias for amdvlk from nixpkgs unstable
  (import ./amdvlkUnstable { inherit (flakes) nixpkgs-unstable; })

  # g810-led: LED controller for Logitech keyboards
  (import ./g810-led)

  # TODO Remove on 21.05.
  # libstrangle: Get from nixpkgs unstable.
  (import ./libstrangle { inherit (flakes) nixpkgs-unstable; })

  # TODO Remove on 21.05.
  # linuxPackages_zen: Add kernel modules (hid-playstation & rtw88).
  (import ./linuxPackages_zen)

  # mesaUnstable: Alias for mesa from nixpkgs unstable
  (import ./mesaUnstable { inherit (flakes) nixpkgs-unstable; })

  # mpv: Add custom scripts.
  (import ./mpv)

  # mpvScripts.sponsorblock: Change default options.
  (import ./mpv/sponsorblock.nix)

  # mpvScripts.youtube-quality: Init
  (import ./mpv/youtube-quality.nix)

  # nix-zsh-completions: Add experimental flake support.
  (import ./nix-zsh-completions)

  # pcsx2: Build with native compiler optimizations.
  (import ./pcsx2)

  # plasma5.kwin: Apply low latency patch.
  (import ./kwin)

  # TODO Remove on 21.05.
  # plasma5Packages: Alias for packages related to Plasma 5.
  (import ./plasma5Packages)

  # steam: Add cabextract, needed for protontricks to install MS core fonts.
  (import ./steam)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

  # winetricks: Use wine staging with both 32-bit and 64-bit support.
  (import ./winetricks)

]
