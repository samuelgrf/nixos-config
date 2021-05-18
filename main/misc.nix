{

  # Wipe /tmp on boot.
  boot.cleanTmpDir = true;

  # Use Qt dialogs in supported GTK applications.
  xdg.portal.gtkUsePortal = true;

  # Show Proton builds from `~/.steam/root/compatibilitytools.d` in Lutris.
  environment.variables.LUTRIS_ENABLE_PROTON = "1";

  # Fix `install-info: Cannot allocate memory for gzip -d` on rebuild.
  # TODO Remove when https://github.com/NixOS/nixpkgs/issues/124215 is fixed.
  documentation.info.enable = false;

}
