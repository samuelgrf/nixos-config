{

  # Enable the KDE Plasma desktop environment.
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  # Enable automatic login.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "samuel";

  # Enable and configure ZFS auto-snapshotting service.
  # To activate auto-snapshotting for a dataset run
  # `sudo zfs set com.sun:auto-snapshot=true <DATASET>`.
  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 4; # 15 minutes
    hourly = 24;
    daily = 7;
    weekly = 4;
    monthly = 12;
  };

  # Enable unclutter-xfixes to hide the mouse cursor when inactive.
  services.unclutter-xfixes.enable = true;

  # Enable Emacs daemon.
  services.emacs.enable = true;
  services.emacs.defaultEditor = true;

  # Enable Early OOM deamon.
  services.earlyoom.enable = true;

  # Enable OpenSSH agent.
  programs.ssh.startAgent = true;

  # Enable GnuPG agent.
  programs.gnupg.agent.enable = true;

}
