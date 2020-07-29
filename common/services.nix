{ config, pkgs, ... }:

{
  # Enable the KDE Plasma desktop environment.
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm = {
    enable = true;
    autoLogin.enable = true;
    autoLogin.user = "samuel";
  };

  # Hides the mouse cursor if it isn’t being moved.
  systemd.user.services.unclutter = {
    description = "unclutter-xfixes";
    script = "${pkgs.unclutter-xfixes}/bin/unclutter";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };

  # Enable Emacs daemon.
  services.emacs.enable = true;
  services.emacs.defaultEditor = true;

  # Enable Early OOM deamon.
  services.earlyoom.enable = true;

  # Enable OpenSSH daemon.
  # services.openssh.enable = true;
}
