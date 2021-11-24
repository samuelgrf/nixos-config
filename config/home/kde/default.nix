{ binPaths, lib, nixos-artwork, nixosConfig, ... }: {

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
      (import ./hotkeys.nix { inherit binPaths; })
      (import ./keyboard.nix { inherit nixosConfig; })
      (import ./wallpaper.nix { inherit nixos-artwork; })
    ]);
  };

  imports = [ ./locale.nix ];
}
