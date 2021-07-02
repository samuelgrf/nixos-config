{ lib, nixos-artwork, ... }: {

  programs.kde = {
    enable = true;
    settings = lib.mkMerge [
      (import ./ark.nix)
      (import ./dolphin.nix)
      (import ./hotkeys.nix)
      (import ./kate.nix)
      (import ./konsole.nix)
      (import ./kwin.nix)
      (import ./misc.nix)
      (import ./power-management.nix)
      (import ./wallpaper.nix { inherit nixos-artwork; })
    ];
  };

}
