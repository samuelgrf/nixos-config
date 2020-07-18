{ config, pkgs, ... }:

let
  trueIfX = if config.services.xserver.enable then true else false;
in
{
  # Enable KDE Plasma 5
  services.xserver.desktopManager.plasma5.enable = trueIfX;
  services.xserver.displayManager.sddm = {
    enable = trueIfX;
    autoLogin.enable = trueIfX;
    autoLogin.user = "samuel";
  };

  # Hides the mouse cursor if it isn’t being moved
  systemd.user.services.unclutter = {
    description = "unclutter-xfixes";
    script = "${pkgs.unclutter-xfixes}/bin/unclutter";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };

  # Configure Emacs
  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = with pkgs; (if trueIfX then emacs else emacs-nox);
  };

  # Enable Early OOM
  services.earlyoom.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
}
