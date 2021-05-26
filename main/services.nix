{ avahi, binPaths, config, lib, writeShellScript, ... }: {

  # Enable and configure desktop environment.
  services.xserver = {

    # Enable KDE Plasma with Display Data Channel support.
    desktopManager.plasma5 = {
      enable = true;
      supportDDC = true;
    };

    # Enable SDDM session manager and log in automatically.
    displayManager = {
      sddm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "samuel";
    };
  };

  # Enable and configure PipeWire audio server.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable NetworkManager daemon.
  networking.networkmanager.enable = true;

  # Enable and configure Avahi daemon for zero-configuration networking.
  services.avahi = {
    enable = true;
    extraServiceFiles.ssh = "${avahi}/etc/avahi/services/ssh.service";
  };

  # Enable and configure ZFS services.
  services.zfs = {

    # To activate auto-snapshotting for a dataset run
    # `sudo zfs set com.sun:auto-snapshot=true <DATASET>`.
    autoSnapshot = {
      enable = true;
      frequent = 4; # 15 minutes
      hourly = 24;
      daily = 7;
      weekly = 4;
      monthly = 0;
    };

    # Scrub ZFS pools to verify and restore filesystem integrity.
    autoScrub = {
      enable = true;
      interval = "Mon";
    };

    # To activate trimming for a LUKS device set
    # `boot.initrd.luks.devices.<name>.allowDiscards = true`.
    trim = {
      enable = true;
      interval = "Thu";
    };
  };

  # Wait for running ZFS operations to end before scrub & trim.
  systemd.services = with binPaths;
    let scrubCfg = config.services.zfs.autoScrub;
    in {
      zfs-scrub.serviceConfig.ExecStart = lib.mkForce
        (writeShellScript "zfs-scrub" ''
          for pool in ${
            if scrubCfg.pools != [ ] then
              (concatStringsSep " " scrubCfg.pools)
            else
              "$(${zpool} list -H -o name)"
          }; do
            echo Waiting for ZFS operations running on $pool to end...
            ${zpool} wait $pool
            echo Starting ZFS scrub for $pool...
            ${zpool} scrub $pool
          done
        '');

      zpool-trim.serviceConfig = {
        ExecStart = lib.mkForce (writeShellScript "zpool-trim" ''
          for pool in $(${zpool} list -H -o name); do
            echo Waiting for ZFS operations running on $pool to end...
            ${zpool} wait $pool
            echo Starting TRIM operation for $pool...
            ${zpool} trim $pool
          done
        '');
        Type = "oneshot";
      };
    };

  # Enable Early OOM deamon.
  services.earlyoom.enable = true;

  # Enable and configure Emacs daemon.
  services.emacs = {
    enable = true;
    defaultEditor = true;
  };

  # Enable and configure OpenSSH utilities.
  services.openssh.enable = true;
  programs.ssh = {
    startAgent = true; # Enable key manager.
    askPassword = ""; # Disable GUI password prompt.
  };
  users.users = {
    samuel.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwTxBMRYCd0AKW5vDWbOuyfevl+VH/ntDwrvFw5rbzt samuel@amethyst"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDnGnsUmj08UT8r8nDfStCgDpo0e2KrhTb+69e2QKZvA samuel@beryl"
    ];
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC68A6rSbE4UeZgTLJKiIVbTgZRgeeVy8P2BWWgVbWp6 root@amethyst"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJeWZ1+Yxu0qcL131/4M3o0++qNgFXANrTxSJe8JbzZa root@beryl"
    ];
  };

  # Enable GnuPG agent.
  programs.gnupg.agent.enable = true;

  # Enable unclutter-xfixes to hide the mouse cursor when inactive.
  services.unclutter-xfixes.enable = true;

}
