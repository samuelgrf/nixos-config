{

  # Disable GUI password prompt when using SSH.
  programs.ssh.askPassword = "";

  # Use Qt dialogs in supported GTK applications.
  xdg.portal.gtkUsePortal = true;

  # Wipe /tmp on boot.
  boot.cleanTmpDir = true;

  # Show Proton builds from `~/.steam/root/compatibilitytools.d` in Lutris.
  environment.variables.LUTRIS_ENABLE_PROTON = "1";

}
