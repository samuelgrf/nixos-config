{ lib, nixos-artwork, nixosConfig, ... }: {

  programs.kde = {
    enable = true;
    settings = lib.mkMerge ((map import [
      ./ark.nix
      ./dolphin.nix
      ./hotkeys.nix
      ./kate.nix
      ./konsole.nix
      ./kwin.nix
      ./misc.nix
      ./power-management.nix
    ]) ++ [
      (import ./keyboard.nix { inherit nixosConfig; })
      (import ./wallpaper.nix { inherit nixos-artwork; })
    ]);
  };

  imports = [ ./locale.nix ];
}
