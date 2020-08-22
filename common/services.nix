{ config, pkgs, ... }:

{
  # Enable the KDE Plasma desktop environment.
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm = {
    enable = true;
    autoLogin.enable = true;
    autoLogin.user = "samuel";
  };

  # Enable unclutter-xfixes to hide the mouse cursor when inactive.
  services.unclutter-xfixes.enable = true;

  # Enable Emacs daemon.
  services.emacs.enable = true;
  services.emacs.defaultEditor = true;

  # Enable Early OOM deamon.
  services.earlyoom.enable = true;

  # Enable OpenSSH daemon.
  # services.openssh.enable = true;
}
