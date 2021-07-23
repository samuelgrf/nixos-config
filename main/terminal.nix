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
        dir #                     current directory
        vcs #                     git status
        prompt_char #             prompt symbol
      )
      POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
        status #                  exit code of the last command
        command_execution_time #  duration of the last command
        background_jobs #         presence of background jobs
        context #                 user@hostname
        vim_shell #               vim shell indicator (:sh)
        nix_shell #               nix shell indicator
        time #                    current time
      )
      # Use fewer icons.
      POWERLEVEL9K_DIR_CLASSES=()
      POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
      POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=
      POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=

      # Disable less history.
      export LESSHISTFILE=/dev/null

      # Define Nix & NixOS functions.
      nr () {(
        set -eo pipefail

        oldNixosGen="$(${readlink} -f '/run/current-system')"
        origArgs=("$@")

        while [ "$#" -gt 0 ]; do
          i="$1"; shift 1
          case "$i" in
            switch|boot|test|build|edit|dry-build|dry-run|dry-activate|build-vm|build-vm-with-bootloader)
              action="$i"
            ;;
            --build-host|h)
              buildHost="$1"
              shift 1
            ;;
            --target-host|t)
              targetHost="$1"
              shift 1
            ;;
          esac
        done

        [[ -z "$buildHost" && -n "$targetHost" ]] && buildHost="$targetHost"
        [ "$targetHost" = localhost ] && targetHost=
        [ "$buildHost" = localhost ] && buildHost=

        ${sudo} ${nixos-rebuild} -v "''${origArgs[@]}"

        if [ -z "$targetHost" ]; then
          if [[ "$action" = boot || "$action" = switch ]]; then
            newNixosGen="$(${readlink} -f '/nix/var/nix/profiles/system')"
            ${nvd} diff "$oldNixosGen" "$newNixosGen"
          elif [ -z "$buildHost" ]; then
            newNixosGen="$(${readlink} -f 'result')"
            ${nvd} diff "$oldNixosGen" "$newNixosGen"
          fi
        fi
      )}
      nrs () { nr switch "$@" && exec ${zsh} }
      nrt () { nr test "$@" && exec ${zsh} }
      nsd () { ${nix} show-derivation "$@" | ${bat} -l json }
      nsh () { NIXPKGS_ALLOW_UNFREE=1 ${nix} shell --impure nixpkgs#"$@" }
      nshm () { NIXPKGS_ALLOW_UNFREE=1 ${nix} shell --impure github:NixOS/nixpkgs#"$@" }
      nshu () { NIXPKGS_ALLOW_UNFREE=1 ${nix} shell --impure nixpkgs-unstable#"$@" }
      nrn () {(
        set -e

        if [ -z "$flake" ]; then
          flake='nixpkgs'
        fi

        attr="$(${nix-locate} --top-level --minimal --at-root --whole-name "/bin/$1")"
        if [ "$(echo "$attr" | ${wc} -l)" -ne 1 ]; then
          attr="$(echo "$attr" | ${fzy} -l 50)"
        fi

        if [ -z "$attr" ]; then
          >&2 echo "command not found: $1"
          exit 1
        fi

        ${nix} shell "$flake#$attr" --command "$@"
      )}

      # Define other functions.
      command_not_found_handler () { nrn "$@" }
      run () { "$@" &> /dev/null & disown }
    '';

    # Add entries to zshenv.
    shellInit = ''
      # Disable newuser setup (runs if no ~/.zsh* files exist).
      zsh-newuser-install() {}
    '';

    # Set shell aliases.
    shellAliases = let
      configDir = ''$(${dirname} "$(${readlink} -m /etc/nixos/flake.nix)")'';
      docDir = "/run/current-system/sw/share/doc";
    in {

      # Nix & NixOS
      c = ''cd "${configDir}"'';
      hmm =
        "run ${ungoogled-chromium} 'file://${docDir}/home-manager/index.html'";
      hmo =
        "run ${ungoogled-chromium} 'file://${docDir}/home-manager/options.html'";
      n = nix;
      nb = "${nix} build --print-build-logs -v";
      nbd = "${nix} build --dry-run -v";
      nf = "${nix} flake";
      nfc = "${nix} flake check";
      nfl = "${nix} flake lock";
      nfu = "nu";
      nfuc = "nuc";
      nfuci = "nuci";
      nfui = "nui";
      ngd = "${nix} path-info --derivation";
      nlg = "${nix} log";
      nlo = nix-locate;
      nm = "run ${ungoogled-chromium} 'file://${docDir}/nix/manual/index.html'";
      nom = "run ${ungoogled-chromium} 'file://${docDir}/nixos/index.html'";
      noo = "run ${ungoogled-chromium} 'file://${docDir}/nixos/options.html'";
      np = ''${nix} repl "${configDir}/repl.nix"'';
      npl = "${nix} repl";
      npm = "run ${ungoogled-chromium} 'file://${docDir}/nixpkgs/manual.html'";
      nrb = "nr boot";
      nrbu = "nr build";
      nse = "${nix} search nixpkgs";
      nsem = "${nix} search github:NixOS/nixpkgs";
      nseu = "${nix} search nixpkgs-unstable";
      nsr = ''
        ${nix-store} --gc --print-roots |\
          ${cut} -f 1 -d " " |\
          ${grep} '/result-\?[^-]*$'\
      '';
      nsrr = "${rm} -v $(nsr)";
      nu = "${nix} flake update";
      nrnm = "flake=github:NixOS/nixpkgs nrn";
      nrnu = "flake=nixpkgs-unstable nrn";
      nub = "nu && nrb";
      nubu = "nu && nrbu";
      nuc = "${nix} flake update --commit-lock-file";
      nuci = "${nix} flake update --commit-lock-file --update-input";
      nui = "${nix} flake update --update-input";
      nus = "nu && nrs";
      nut = "nu && nrt";
      nv = "echo '${
          lib.concatStringsSep "\n" (lib.mapAttrsToList (name: flake: ''
            ${name}:
              ${flake.rev or "dirty"} (${
                lib.formatDateSep "-" flake.lastModifiedDate or "19700101"
              })'') flakes)
        }'";

      # Other
      chromium-widevine = ''
        run ${pkgs.ungoogled-chromium.override { enableWideVine = true; }}\
        /bin/chromium --user-data-dir="$HOME/.config/chromium-widevine"\
      '';
      clean = ''
        ${sudo} ${systemctl} start nix-gc.service
        ${journalctl} -o cat -fu nix-gc.service
      '';
      cpr = "cp -r";
      e = "run ${emacsclient} -c";
      et = "${emacsclient} -t";
      grl = "${git} reflog";
      grlp = "${git} reflog -p";
      gstlp = "${git} stash list -p";
      inc = ''
        [ -n "$HISTFILE" ] && {\
          echo "Enabled incognito mode"
          unset HISTFILE
        } || {\
          echo "Disabled incognito mode"
          exec ${zsh}
        }\
      '';
      lvl = "echo $SHLVL";
      msg = "${kdialog} --msgbox";
      nw = "whence -ps";
      o = xdg-open;
      p = "${pre-commit} run -a";
      qr = "${qrencode} -t UTF8";
      radio = ''run ${vlc} "${./radio.m3u}"'';
      rb = "${shutdown} -r";
      rbc = "${shutdown} -c";
      rbn = "${shutdown} -r now";
      rld = "exec ${zsh}";
      rldh = ''
        ${sudo} ${systemctl} restart 'home-manager-*.service'
        ${systemctl} status 'home-manager-*.service'\
      '';
      rldp = "${kquitapp5} plasmashell && ${kstart5} plasmashell";
      rmr = "rm -r";
      sd = shutdown;
      sdc = "${shutdown} -c";
      sdn = "${shutdown} now";
      smart = "${sudo} ${smartctl} -a";
      ssha = "${ssh} amethyst";
      sshb = "${ssh} beryl";
      sudo = "${sudo} ";
      t = tree;
      tv = ''run ${vlc} "${./tv.m3u}"'';
      watch = "${watch} ";
      wtr = "${curl} wttr.in";
      zl = "${zfs} list";
      zla = "${zfs} list -t all";
      zlf = "${zfs} list -t filesystem";
      zls = "${zfs} list -t snapshot";
      zlv = "${zfs} list -t volume";
      zs = "${sudo} ${systemctl} start zfs-scrub.service && watch zst";
      zsc = "${sudo} ${zpool} scrub -s rpool; zst";
      zst = "${zpool} status -t rpool";
      zt = "${sudo} ${systemctl} start zpool-trim.service && watch zst";
      ztc = "${sudo} ${zpool} trim -c rpool; zst";
    };
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
