{ config, lib, pkgs, pkgs-emacs, userData, ... }:

with pkgs;

let zpool.exe = "${config.boot.zfs.package}/bin/zpool";
in {

  # Enable and configure desktop & display manager.
  services.xserver = {
    desktopManager.plasma5 = {
      enable = true;
      supportDDC = true;
      runUsingSystemd = true;
    };

    displayManager = {
      lightdm.enable = true;
      defaultSession = "plasmawayland";
      autoLogin = {
        enable = true;
        user = userData.name;
      };
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
      interval = "Fri";
    };

    # To activate trimming for a LUKS device set
    # `boot.initrd.luks.devices.<name>.allowDiscards = true`.
    trim = {
      enable = true;
      interval = "Wed";
    };
  };

  # Wait for running ZFS operations to end before scrub & trim.
  systemd.services.zfs-scrub.serviceConfig.ExecStart =
    let scrubCfg = config.services.zfs.autoScrub;
    in lib.mkForce (writeShellScript "zfs-scrub" ''
      for pool in ${
        if scrubCfg.pools != [ ] then
          (__concatStringsSep " " scrubCfg.pools)
        else
          "$(${zpool.exe} list -H -o name)"
      }; do
        echo Waiting for ZFS operations running on $pool to end...
        ${zpool.exe} wait $pool
        echo Starting ZFS scrub for $pool...
        ${zpool.exe} scrub $pool
      done
    '');

  systemd.services.zpool-trim.serviceConfig = {
    ExecStart = lib.mkForce (writeShellScript "zpool-trim" ''
      for pool in $(${zpool.exe} list -H -o name); do
        echo Waiting for ZFS operations running on $pool to end...
        ${zpool.exe} wait $pool
        echo Starting TRIM operation for $pool...
        ${zpool.exe} trim $pool
      done
    '');
    Type = "oneshot";
  };

  # Ensure one of the timers waits if run simultaneously.
  systemd.timers = {
    zfs-scrub.timerConfig.RandomizedDelaySec = 1;
    zpool-trim.timerConfig.RandomizedDelaySec = 1;
  };

  # Run Nix garbage collector automatically.
  nix.gc = {
    automatic = true;
    dates = "Mon";
    options = "--delete-old";
  };

  systemd.services.nix-gc.serviceConfig = {

    # Remove stray garbage collector roots before GC.
    ExecStartPre = writeShellScript "nix-gc-pre" ''
      echo removing stray garbage collector roots...
      rm -v $(
        ${config.nix.package.exe}-store --gc --print-roots \
          | cut -f 1 -d " " \
          | ${gnugrep.exe} '/result-\?[^-]*$'
      ) || :
    '';

    # Delete inaccessible boot entries after GC.
    ExecStopPost = writeShellScript "nix-gc-post" ''
      echo deleting old boot entries...
      /nix/var/nix/profiles/system/bin/switch-to-configuration boot
    '';
  };

  # Enable Early OOM deamon.
  services.earlyoom.enable = true;

  # Enable and configure Emacs daemon.
  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = pkgs-emacs.emacsPgtkGcc;
  };

  # Enable and configure OpenSSH utilities.
  services.openssh.enable = true;
  programs.ssh = {
    startAgent = true; # Enable key manager.
    askPassword = ""; # Disable GUI password prompt.
  };

  # Enable GnuPG agent.
  programs.gnupg.agent.enable = true;
}
