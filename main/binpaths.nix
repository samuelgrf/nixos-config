# TODO Remove `lib,` on NixOS 21.11.
{ config, lib, pkgs, pkgs-unstable }:

with pkgs;
__mapAttrs (_: lib.mainProgram) pkgs // {

  cut = "${coreutils}/bin/cut";
  dirname = "${coreutils}/bin/dirname";
  emacsclient = "${config.services.emacs.package}/bin/emacsclient";
  # TODO Remove on NixOS 21.11.
  gnugrep = "${gnugrep}/bin/grep";
  # TODO Remove on NixOS 21.11.
  gnused = "${gnused}/bin/sed";
  hda-verb = "${alsaTools}/bin/hda-verb";
  journalctl = "${config.systemd.package}/bin/journalctl";
  kdialog = "${plasma5Packages.kdialog}/bin/kdialog";
  kquitapp5 = "${plasma5Packages.kdbusaddons}/bin/kquitapp5";
  kstart5 = "${plasma5Packages.kde-cli-tools}/bin/kstart5";
  kwriteconfig5 = "${plasma5Packages.kconfig}/bin/kwriteconfig5";
  nix = "${config.nix.package}/bin/nix";
  nix-locate = "${nix-index}/bin/nix-locate";
  nix-store = "${config.nix.package}/bin/nix-store";
  nixos-rebuild = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
  # TODO Remove on NixOS 21.11.
  pipe-rename = "${pkgs-unstable.pipe-rename}/bin/renamer";
  readlink = "${coreutils}/bin/readlink";
  rm = "${coreutils}/bin/rm";
  shutdown = "${config.systemd.package}/bin/shutdown";
  smartctl = "${smartmontools}/bin/smartctl"; # TODO Remove on NixOS 21.11.
  ssh = "${config.programs.ssh.package}/bin/ssh";
  sudo = "${config.security.wrapperDir}/sudo";
  systemctl = "${config.systemd.package}/bin/systemctl";
  watch = "${procps}/bin/watch";
  wc = "${coreutils}/bin/wc";
  xdg-open = "${xdg-utils}/bin/xdg-open";
  zfs = "${config.boot.zfs.package}/bin/zfs";
  zpool = "${config.boot.zfs.package}/bin/zpool";

}
