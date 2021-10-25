{ flakes, lib, ... }: {

  # Wipe /tmp on boot.
  boot.cleanTmpDir = true;

  # Use Qt dialogs in supported GTK applications.
  xdg.portal.gtkUsePortal = true;

  # Expose input flakes to legacy Nix applications.
  environment.variables.NIX_PATH = with lib;
    mkForce (concatStringsSep ":"
      (mapAttrsToList (name: path: "${name}=${path}") flakes));
}
