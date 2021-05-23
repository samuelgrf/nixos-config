{ binPaths, flakes, lib, pkgs, ... }:

with binPaths; {

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
      nr () {
        _NIXOS_OLD_GEN=$(${readlink} /run/current-system)
        ${sudo} ${nixos-rebuild} -v "$@" && {
          [ "$1" = boot -o "$1" = switch ] \
            && _NIXOS_NEW_GEN=$(${readlink} -f /nix/var/nix/profiles/system) \
            || _NIXOS_NEW_GEN=$(${readlink} result)
          ${nvd} diff $_NIXOS_OLD_GEN $_NIXOS_NEW_GEN
        }
      }
      nrs () { nr switch "$@" && exec ${zsh} }
      nrt () { nr test "$@" && exec ${zsh} }
      nsd () { ${nix} show-derivation "$@" | ${bat} -l json }
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
    shellAliases = let
      configDir = "$(${dirname} $(${readlink} -m /etc/nixos/flake.nix))";
      docDir = "/run/current-system/sw/share/doc";
    in {

      # Nix & NixOS
      c = "cd ${configDir}";
      hmm = "${ungoogled-chromium} file://${docDir}/home-manager/index.html";
      hmo = "${man} home-configuration.nix";
      hmv = "${echo} ${flakes.home-manager.rev}";
      n = nix;
      nb = "${nix} build --print-build-logs -v";
      nbd = "${nix} build --dry-run -v";
      nf = "${nix} flake";
      nfc = "${nix} flake check";
      nfl = "${nix} flake lock";
      nfu = "${nix} flake update";
      ngd = "${nix} path-info --derivation";
      nlo = nix-locate;
      nm = "${ungoogled-chromium} file://${docDir}/nix/manual/index.html";
      nmv = "${echo} ${flakes.nixpkgs-master.rev}";
      nom = "${ungoogled-chromium} file://${docDir}/nixos/index.html";
      noo = "${man} configuration.nix";
      np = "${nix} repl";
      npm = "${ungoogled-chromium} file://${docDir}/nixpkgs/manual.html";
      nrb = "nr boot";
      nrbu = "nr build";
      nse = "${nix} search nixpkgs";
      nsem = "${nix} search github:NixOS/nixpkgs";
      nseu = "${nix} search nixpkgs-unstable";
      nsr = ''
        ${nix-store} --gc --print-roots |\
          ${cut} -f 1 -d " " |\
          ${grep} '/result-\?[^-]*$'
      '';
      nsrr = "${rm} -v $(nsr)";
      nu = "cd ${configDir} && nfu --commit-lock-file";
      nub = "nu && nr boot";
      nubu = "nu && nr build";
      nui = "cd ${configDir} && nfl --commit-lock-file --update-input";
      nuv = "${echo} ${flakes.nixpkgs-unstable.rev}";
      nv = "${echo} ${flakes.nixpkgs.rev}";
      r = "${nix} repl ${configDir}/repl.nix";

      # Other
      chromium-widevine = ''
        ${pkgs.ungoogled-chromium.override { enableWideVine = true; }}\
        /bin/chromium --user-data-dir=$HOME/.config/chromium-widevine &\
        disown
        exit\
      '';
      clean = lib.sudoZshICmd ''
        ${rm} -v $(nsr)
        ${nix-collect-garbage} -d &&\
        ${echo} "deleting unused boot entries..." &&\
        /nix/var/nix/profiles/system/bin/switch-to-configuration boot &&\
        ztr\
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
      rm = rmtrash;
      rmdir = rmdirtrash;
      rme = trash-empty;
      rml = trash-list;
      rmr = "${rmtrash} -r";
      rmu = trash-restore;
      sd = shutdown;
      sdc = "${shutdown} -c";
      sdn = "${shutdown} now";
      ssha = "${ssh} amethyst";
      sshb = "${ssh} beryl";
      sudo = "${sudo} ";
      t = tree;
      tv = "${vlc} ${./tv.m3u}";
      watch = "${watch} ";
      wtr = "${curl} wttr.in";
      zl = "${zfs} list";
      zla = "${zfs} list -t all";
      zlf = "${zfs} list -t filesystem";
      zls = "${zfs} list -t snapshot";
      zlv = "${zfs} list -t volume";
      zsr = "${sudo} ${zpool} scrub rpool && watch zstr";
      zsrc = "${sudo} ${zpool} scrub -s rpool; zstr";
      zstr = "${sudo} ${zpool} status -t rpool";
      ztr = "${sudo} ${zpool} trim rpool && watch zstr";
      ztrc = "${sudo} ${zpool} trim -c rpool; zstr";
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
