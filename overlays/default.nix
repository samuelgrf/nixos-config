{ flakes }: [

  # amdvlkUnstable: Alias for amdvlk from nixpkgs unstable
  (import ./amdvlkUnstable { inherit flakes; })

  # g810-led: LED controller for Logitech keyboards
  (import ./g810-led)

  # kwin: Apply low latency patch.
  (import ./kwin)

  # TODO Remove on 21.05.
  # linuxPackages_zen: Add kernel modules (hid-playstation & rtw88).
  (import ./linuxPackages_zen)

  # mesaUnstable: Alias for mesa from nixpkgs unstable
  (import ./mesaUnstable { inherit flakes; })

  # mpv: Add custom scripts to mpv.
  (import ./mpv)

  # mpvScripts.sponsorblock: Change default options.
  (import ./mpv/sponsorblock.nix)

  # mpvScripts.youtube-quality: Init
  (import ./mpv/youtube-quality.nix)

  # nix-zsh-completions: Add experimental flake support.
  (import ./nix-zsh-completions)

  # pcsx2: Build with native compiler optimizations.
  (import ./pcsx2)

  # steam: Add cabextract, needed for protontricks to install MS core fonts.
  (import ./steam)

  # ungoogled-chromium: Add command line arguments.
  (import ./ungoogled-chromium)

  # winetricks: Use wine staging with both 32-bit and 64-bit support.
  (import ./winetricks)

]
