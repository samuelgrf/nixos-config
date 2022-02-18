{ flakes, lib, pkgs, ... }: {

  # Wipe /tmp on boot.
  boot.cleanTmpDir = true;

  # GTK: Fix font aliasing and use Qt dialogs if supported.
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  xdg.portal.gtkUsePortal = true;

  # Expose input flakes to legacy Nix applications.
  environment.variables.NIX_PATH = with lib;
    mkForce (concatStringsSep ":"
      (mapAttrsToList (name: path: "${name}=${path}") flakes));
}
