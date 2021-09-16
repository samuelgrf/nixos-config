{ config, pkgs }:

with pkgs; {

  bat = "${bat}/bin/bat";
  curl = "${curl}/bin/curl";
  cut = "${coreutils}/bin/cut";
  dirname = "${coreutils}/bin/dirname";
  emacsclient = "${config.services.emacs.package}/bin/emacsclient";
  fzy = "${fzy}/bin/fzy";
  git = "${git}/bin/git";
  git-open = "${git-open}/bin/git-open";
  grep = "${gnugrep}/bin/grep";
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
  nvd = "${nvd}/bin/nvd";
  pre-commit = "${pre-commit}/bin/pre-commit";
  qrencode = "${qrencode}/bin/qrencode";
  readlink = "${coreutils}/bin/readlink";
  rm = "${coreutils}/bin/rm";
  shutdown = "${config.systemd.package}/bin/shutdown";
  smartctl = "${smartmontools}/bin/smartctl";
  ssh = "${config.programs.ssh.package}/bin/ssh";
  sudo = "${config.security.wrapperDir}/sudo";
  systemctl = "${config.systemd.package}/bin/systemctl";
  tree = "${tree}/bin/tree";
  ungoogled-chromium = "${ungoogled-chromium}/bin/chromium";
  vlc = "${vlc}/bin/vlc";
  watch = "${procps}/bin/watch";
  wc = "${coreutils}/bin/wc";
  xdg-open = "${xdg-utils}/bin/xdg-open";
  zfs = "${config.boot.zfs.package}/bin/zfs";
  zpool = "${config.boot.zfs.package}/bin/zpool";
  zsh = "${zsh}/bin/zsh";

}
