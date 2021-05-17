{ config, flakes, lib, pkgs, ... }:

let
  bat = "${pkgs.bat}/bin/bat";
  curl = "${pkgs.curl}/bin/curl";
  cut = "${pkgs.coreutils}/bin/cut";
  dirname = "${pkgs.coreutils}/bin/dirname";
  echo = "${pkgs.coreutils}/bin/echo";
  emacsclient = "${config.services.emacs.package}/bin/emacsclient";
  git = "${pkgs.git}/bin/git";
  grep = "${pkgs.gnugrep}/bin/grep";
  kdialog = "${pkgs.kdeGear.kdialog}/bin/kdialog";
  kquitapp5 = "${pkgs.kdeGear.kdbusaddons}/bin/kquitapp5";
  kstart5 = "${pkgs.kdeGear.kdbusaddons}/bin/kstart5";
  less = "${pkgs.less}/bin/less";
  man = "${pkgs.man-db}/bin/man";
  nix = "${config.nix.package}/bin/nix";
  nix-collect-garbage = "${config.nix.package}/bin/nix-collect-garbage";
  nix-locate = "${pkgs.nix-index}/bin/nix-locate";
  nix-store = "${config.nix.package}/bin/nix-store";
  nixos-rebuild = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
  pre-commit = "${pkgs.pre-commit}/bin/pre-commit";
  qrencode = "${pkgs.qrencode}/bin/qrencode";
  readlink = "${pkgs.coreutils}/bin/readlink";
  rm = "${pkgs.coreutils}/bin/rm";
  shutdown = "${config.systemd.package}/bin/shutdown";
  smartctl = "${pkgs.smartmontools}/bin/smartctl";
  sudo = "${config.security.wrapperDir}/sudo";
  systemctl = "${config.systemd.package}/bin/systemctl";
  tree = "${pkgs.tree}/bin/tree";
  ungoogled-chromium = "${pkgs.ungoogled-chromium}/bin/chromium";
  vlc = "${pkgs.vlc}/bin/vlc";
  watch = "${pkgs.procps}/bin/watch";
  xdg-open = "${pkgs.xdg_utils}/bin/xdg-open";
  zfs = "${
      if config.boot.zfs.enableUnstable then pkgs.zfsUnstable else pkgs.zfs
    }/bin/zfs";
  zpool = "${
      if config.boot.zfs.enableUnstable then pkgs.zfsUnstable else pkgs.zfs
    }/bin/zpool";
  zsh = "${pkgs.zsh}/bin/zsh";
in {

  # Use X keyboard configuration on console.
  console.useXkbConfig = true;

  # Set Zsh as default shell.
  users.defaultUserShell = pkgs.zsh;

  # Configure Zsh.
  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git" ];
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # Add entries to zshrc.
    interactiveShellInit = ''
      # Load and configure Powerlevel10k theme.
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/config/p10k-lean.zsh
      POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
        dir                     # current directory
        vcs                     # git status
        prompt_char             # prompt symbol
      )
      POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
        status                  # exit code of the last command
        command_execution_time  # duration of the last command
        background_jobs         # presence of background jobs
        context                 # user@hostname
        vim_shell               # vim shell indicator (:sh)
        nix_shell               # nix shell indicator
        time                    # current time
      )
      # Use fewer icons.
      POWERLEVEL9K_DIR_CLASSES=()
      POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
      POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=
      POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=

      # Load the nix-index `command-not-found` replacement.
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

      # Disable less history.
      export LESSHISTFILE=/dev/null

      # Define Nix & NixOS functions.
      nr () { ${sudo} ${nixos-rebuild} -v "$@" }
      nrs () { nr switch "$@" && exec ${zsh} }
      nrt () { nr test "$@" && exec ${zsh} }
      nsd () { ${nix} show-derivation "$@" | ${bat} -l nix }
      nsh () { NIXPKGS_ALLOW_UNFREE=1 ${nix} shell --impure nixpkgs#"$@" }
      nshm () { NIXPKGS_ALLOW_UNFREE=1 ${nix} shell --impure github:NixOS/nixpkgs#"$@" }
      nshu () { NIXPKGS_ALLOW_UNFREE=1 ${nix} shell --impure nixpkgs-unstable#"$@" }
      nus () { nu && nr switch "$@" && exec ${zsh} }
      nut () { nu && nr test "$@" && exec ${zsh} }
      nw () { ${readlink} "$(where "$@")" }
      run () { NIXPKGS_ALLOW_UNFREE=1 ${nix} run --impure nixpkgs#"$@" }
      runm () { NIXPKGS_ALLOW_UNFREE=1 ${nix} run --impure github:NixOS/nixpkgs#"$@" }
      runu () { NIXPKGS_ALLOW_UNFREE=1 ${nix} run --impure nixpkgs-unstable#"$@" }

      # Define other functions.
      e () { ${emacsclient} -c "$@" > /dev/null & disown }
      et () { ${emacsclient} -t "$@" }
      smart () { ${sudo} ${smartctl} -a "$@" | ${less} }
    '';

    # Add entries to zshenv.
    shellInit = ''
      # Disable newuser setup (runs if no ~/.zsh* files exist).
      zsh-newuser-install() {}
    '';

    # Set shell aliases.
    shellAliases =
      let configDir = "$(${dirname} $(${readlink} -m /etc/nixos/flake.nix))";
      in rec {

        # Nix & NixOS
        c = "cd ${configDir}";
        hmm =
          "${ungoogled-chromium} file:///run/current-system/sw/share/doc/home-manager/index.html";
        hmo = "${man} home-configuration.nix";
        hmv = "${echo} ${flakes.home-manager.rev}";
        n = nix;
        nb = "${nix} build --print-build-logs -v";
        nbd = "${nix} build --dry-run -v";
        nf = "${nix} flake";
        nfc = "${nix} flake check";
        nfl = "${nix} flake lock";
        nfu = "${nix} flake update";
        ng = nix-collect-garbage;
        ngd = "${sudo} ${nix-collect-garbage} -d";
        nlo = nix-locate;
        nm =
          "${ungoogled-chromium} file:///run/current-system/sw/share/doc/nix/manual/index.html";
        nom =
          "${ungoogled-chromium} file:///run/current-system/sw/share/doc/nixos/index.html";
        noo = "${man} configuration.nix";
        np = "${nix} repl";
        npm =
          "${ungoogled-chromium} file:///run/current-system/sw/share/doc/nixpkgs/manual.html";
        nrb = "nr boot";
        nrbu = "nr build";
        nse = "${nix} search nixpkgs";
        nsem = "${nix} search github:NixOS/nixpkgs";
        nseu = "${nix} search nixpkgs-unstable";
        nsr =
          "${nix-store} --gc --print-roots | ${cut} -f 1 -d ' ' | ${grep} /result$";
        nsrr = "${rm} -v $(nsr)";
        nu = "cd ${configDir} && ${nix} flake update --commit-lock-file";
        nub = "nu && nr boot";
        nubu = "nu && nr build";
        nui =
          "cd ${configDir} && nix flake lock --commit-lock-file --update-input";
        nv = "${echo} ${flakes.nixpkgs.rev}";
        nvu = "${echo} ${flakes.nixpkgs-unstable.rev}";
        nvm = "${echo} ${flakes.nixpkgs-master.rev}";
        r = "${nix} repl ${configDir}/repl.nix";

        # Other
        chromium-widevine = ''
          ${pkgs.ungoogled-chromium.override { enableWideVine = true; }}\
          /bin/chromium --user-data-dir=$HOME/.config/chromium-widevine &\
          disown
          exit\
        '';
        clean = lib.sudoShCmd ''
          ${rm} -v $(nsr)
          ${nix-collect-garbage} -d &&\
          ${echo} "deleting unused boot entries..." &&\
          /nix/var/nix/profiles/system/bin/switch-to-configuration boot &&\
          ${ztr}\
        '';
        grl = "${git} reflog";
        grlp = "${git} reflog -p";
        inc = ''
          [ -n "$HISTFILE" ] && {\
            ${echo} "Enabled incognito mode"
            unset HISTFILE
          } || {\
            ${echo} "Disabled incognito mode"
            exec ${zsh}
          }\
        '';
        lvl = "${echo} $SHLVL";
        msg = "${kdialog} --msgbox";
        o = xdg-open;
        p = "${pre-commit} run -a";
        qr = "${qrencode} -t UTF8";
        radio = "${vlc} ${./radio.m3u}";
        rb = "${shutdown} -r";
        rbc = "${shutdown} -c";
        rbn = "${shutdown} -r now";
        rld = "exec ${zsh}";
        rldh = lib.sudoShCmd ''
          ${systemctl} restart home-manager-*.service
          ${systemctl} status home-manager-*.service\
        '';
        rldp = "${kquitapp5} plasmashell && ${kstart5} plasmashell";
        sd = shutdown;
        sdc = "${shutdown} -c";
        sdn = "${shutdown} now";
        t = tree;
        tv = "${vlc} ${./tv.m3u}";
        wtr = "${curl} wttr.in";
        zl = "${zfs} list";
        zla = "${zfs} list -t all";
        zlf = "${zfs} list -t filesystem";
        zls = "${zfs} list -t snapshot";
        zlv = "${zfs} list -t volume";
        zsr =
          "${sudo} ${zpool} scrub rpool && ${watch} ${zpool} status -t rpool";
        zsrc = "${sudo} ${zpool} scrub -s rpool; ${zpool} status -t rpool";
        ztr =
          "${sudo} ${zpool} trim rpool && ${watch} ${zpool} status -t rpool";
        ztrc = "${sudo} ${zpool} trim -c rpool; ${zpool} status -t rpool";
      };

    # Set Zsh options.
    setOptions = [ "HIST_FCNTL_LOCK" "HIST_IGNORE_DUPS" "SHARE_HISTORY" ];
  };

  # Add entries to top of zshrc.
  environment.etc.zshrc.text = lib.mkBefore ''
    # Enable Powerlevel10k instant prompt.
    if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
      source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
    fi
  '';

  # Override Oh My Zsh defaults.
  environment.extraInit = "export LESS='-i -F -R'";

  # Disable the default `command-not-found` script (no flake support).
  programs.command-not-found.enable = false;

}
