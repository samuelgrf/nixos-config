{ config, lib, pkgs }:

with pkgs;
__mapAttrs (_: lib.mainProgram) pkgs // {

  cut = "${coreutils}/bin/cut";
  dirname = "${coreutils}/bin/dirname";
  emacsclient = "${config.services.emacs.package}/bin/emacsclient";
  hda-verb = "${alsa-tools}/bin/hda-verb";
  journalctl = "${config.systemd.package}/bin/journalctl";
  kdialog = "${plasma5Packages.kdialog}/bin/kdialog";
  kquitapp5 = "${plasma5Packages.kdbusaddons}/bin/kquitapp5";
  kstart5 = "${plasma5Packages.kde-cli-tools}/bin/kstart5";
  kwriteconfig5 = "${plasma5Packages.kconfig}/bin/kwriteconfig5";
  nix = "${config.nix.package}/bin/nix";
  nix-locate = "${nix-index}/bin/nix-locate";
  nix-store = "${config.nix.package}/bin/nix-store";
  nixos-rebuild = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
  realpath = "${coreutils}/bin/realpath";
  rm = "${coreutils}/bin/rm";
  shutdown = "${config.systemd.package}/bin/shutdown";
  ssh = "${config.programs.ssh.package}/bin/ssh";
  sudo = "${config.security.wrapperDir}/sudo";
  systemctl = "${config.systemd.package}/bin/systemctl";
  watch = "${procps}/bin/watch";
  wc = "${coreutils}/bin/wc";
  xdg-open = "${xdg-utils}/bin/xdg-open";
  zfs = "${config.boot.zfs.package}/bin/zfs";
  zpool = "${config.boot.zfs.package}/bin/zpool";
}
