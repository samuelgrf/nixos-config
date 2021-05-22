{ config, pkgs, pkgs-unstable }:

with pkgs; {

  bat = "${bat}/bin/bat";
  curl = "${curl}/bin/curl";
  cut = "${coreutils}/bin/cut";
  dirname = "${coreutils}/bin/dirname";
  echo = "${coreutils}/bin/echo";
  emacsclient = "${config.services.emacs.package}/bin/emacsclient";
  git = "${git}/bin/git";
  grep = "${gnugrep}/bin/grep";
  hda-verb = "${alsaTools}/bin/hda-verb";
  kdialog = "${kdeGear.kdialog}/bin/kdialog";
  kquitapp5 = "${kdeGear.kdbusaddons}/bin/kquitapp5";
  kstart5 = "${kdeGear.kdbusaddons}/bin/kstart5";
  kwriteconfig5 = "${kdeGear.kconfig}/bin/kwriteconfig5";
  less = "${less}/bin/less";
  man = "${man-db}/bin/man";
  nix = "${config.nix.package}/bin/nix";
  nix-collect-garbage = "${config.nix.package}/bin/nix-collect-garbage";
  nix-locate = "${nix-index}/bin/nix-locate";
  nix-store = "${config.nix.package}/bin/nix-store";
  nixos-rebuild = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
  nvd = "${pkgs-unstable.nvd}/bin/nvd";
  pre-commit = "${pre-commit}/bin/pre-commit";
  qrencode = "${qrencode}/bin/qrencode";
  readlink = "${coreutils}/bin/readlink";
  rm = "${coreutils}/bin/rm";
  rmdirtrash = "${rmtrash}/bin/rmdirtrash";
  rmtrash = "${rmtrash}/bin/rmtrash";
  shutdown = "${config.systemd.package}/bin/shutdown";
  smartctl = "${smartmontools}/bin/smartctl";
  sudo = "${config.security.wrapperDir}/sudo";
  systemctl = "${config.systemd.package}/bin/systemctl";
  trash-empty = "${trash-cli}/bin/trash-empty";
  trash-list = "${trash-cli}/bin/trash-list";
  trash-restore = "${trash-cli}/bin/trash-restore";
  tree = "${tree}/bin/tree";
  ungoogled-chromium = "${ungoogled-chromium}/bin/chromium";
  vlc = "${vlc}/bin/vlc";
  watch = "${procps}/bin/watch";
  xdg-open = "${xdg_utils}/bin/xdg-open";
  zfs =
    "${if config.boot.zfs.enableUnstable then zfsUnstable else zfs}/bin/zfs";
  zpool =
    "${if config.boot.zfs.enableUnstable then zfsUnstable else zfs}/bin/zpool";
  zsh = "${zsh}/bin/zsh";

}
