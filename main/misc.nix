{ ... }:

{
  # Disable GUI password prompt when using SSH.
  programs.ssh.askPassword = "";

  # Use Qt dialogs in supported GTK applications.
  xdg.portal.gtkUsePortal = true;

  # Wipe /tmp on boot.
  boot.cleanTmpDir = true;
}
