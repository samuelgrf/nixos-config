{ lib, nixosConfig, pkgs, ... }: {

  programs.kde = {
    enable = true;
    settings = lib.mkMerge ((map import [
      ./ark.nix
      ./dolphin.nix
      ./kate.nix
      ./konsole.nix
      ./kwin.nix
      ./misc.nix
      ./power-management.nix
    ]) ++ [
      (import ./hotkeys.nix { inherit pkgs; })
      (import ./keyboard.nix { inherit nixosConfig; })
      (import ./wallpaper.nix { inherit pkgs; })
    ]);
  };

  imports = [ ./locale.nix ];
}
