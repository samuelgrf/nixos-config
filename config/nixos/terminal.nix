{ binPaths, config, flakes, lib, pkgs, ... }:

with binPaths; {

  # Use X keyboard configuration on console.
  console.useXkbConfig = true;

  # Set Zsh as default shell.
  users.defaultUserShell = pkgs.zsh;

  # /etc/zshrc
  environment.etc.zshrc.text = lib.mkMerge [
    ''
      # Load and configure Powerlevel10k theme.
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/config/p10k-lean.zsh
      POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
        dir         # current directory
        vcs         # git status
        prompt_char # prompt symbol
      )
      POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
        status                 # exit code of the last command
        command_execution_time # duration of the last command
        background_jobs        # presence of background jobs
        context                # user@hostname
        vim_shell              # vim shell indicator (:sh)
        nix_shell              # nix shell indicator
        time                   # current time
      )
      # Use fewer icons.
      POWERLEVEL9K_DIR_CLASSES=()
      POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
      POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=
      POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=

      # Load Fast Syntax Highlighting.
      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

      # Run unavailable commands via Nix.
      command_not_found_handler() { nrn "$@" }

      # Disable less history.
      export LESSHISTFILE=/dev/null
    ''
    (lib.mkBefore ''
      # Enable Powerlevel10k instant prompt.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '')
    (lib.mkAfter ''
      # Override Oh My Zsh defaults.
      export LESS='-i -F -R'
    '')
  ];

  # /etc/zshenv
  environment.etc.zshenv.text = ''
    # Disable Powerlevel10k new user setup (runs if no ~/.zsh* files exist).
    zsh-newuser-install() {}
  '';

  # Configure Zsh.
  programs.zsh = let
    configDir = ''$(${dirname} "$(${realpath} /etc/nixos/flake.nix)")'';
    docDir = "/run/current-system/sw/share/doc";
  in {
    enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git" ];
    autosuggestions.enable = true;

    # Set shell aliases.
    shellAliases = let f = x: "f() { ${x} }; f";
    in {

      # Nix & NixOS
      c = ''cd "${configDir}"'';
      hmm =
        "run ${ungoogled-chromium} 'file://${docDir}/home-manager/index.html'";
      hmo = "${man} home-configuration.nix";
      n = nix;
      nb = "${nix} build --print-build-logs -v";
      nbd = "${nix} build --dry-run -v";
      nd = "${nix} develop";
      ne = f ''
        ${nix} eval --impure --expr "with import ${configDir}/repl.nix; $@" \
          | ${gnused} 's/^"\(.*\)"$/\1/'
      '';
      nf = "${nix} flake";
      nfc = "${nix} flake check";
      nfl = "${nix} flake lock";
      nfu = "nu";
      nfuc = "nuc";
      nfui = "nui";
      nfuic = "nuic";
      ngd = "${nix} path-info --derivation";
      nlg = "${nix} log";
      nlo = nix-locate;
      nm = "run ${ungoogled-chromium} 'file://${docDir}/nix/manual/index.html'";
      nom = "run ${ungoogled-chromium} 'file://${docDir}/nixos/index.html'";
      noo = "${man} configuration.nix";
      np = ''${nix} repl "${configDir}/repl.nix"'';
      npl = "${nix} repl";
      npm = "run ${ungoogled-chromium} 'file://${docDir}/nixpkgs/manual.html'";
      nr = f ''
        (set -eo pipefail

        oldNixosGen="$(${realpath} '/run/current-system')"
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
            newNixosGen="$(${realpath} '/nix/var/nix/profiles/system')"
            ${nvd} diff "$oldNixosGen" "$newNixosGen"
          elif [ -z "$buildHost" ]; then
            newNixosGen="$(${realpath} 'result')"
            ${nvd} diff "$oldNixosGen" "$newNixosGen"
          fi
        fi)
      '';
      nrb = "nr boot";
      nrbu = "nr build";
      nrn = f ''
        (set -eo pipefail

        attrs=$(${nix-locate} --top-level --minimal --at-root --whole-name "/bin/$1")

        [ -z "$flake" ] && flake=nixpkgs

        if [ "$attrs" ]; then
          attr=$(echo "$attrs" | ${fzy} -l 100)
          ${nix} shell "$flake#$attr" --command "$@"
        else
          >&2 echo "command not found: $1"
          exit 1
        fi)
      '';
      nrnm = "flake=github:NixOS/nixpkgs nrn";
      nrnu = "flake=nixpkgs-unstable nrn";
      nrs = f ''nr switch "$@" && exec ${zsh}'';
      nrt = f ''nr test "$@" && exec ${zsh}'';
      nsd = f ''${nix} show-derivation "$@" | ${bat} -l json'';
      nse = "${nix} search nixpkgs";
      nsem = "${nix} search github:NixOS/nixpkgs";
      nseu = "${nix} search nixpkgs-unstable";
      nsh = f ''${nix} shell nixpkgs#"$@"'';
      nshm = f ''${nix} shell github:NixOS/nixpkgs#"$@"'';
      nshu = f ''${nix} shell nixpkgs-unstable#"$@"'';
      nsr = ''
        ${nix-store} --gc --print-roots \
          | ${cut} -f 1 -d " " \
          | ${gnugrep} '/result-\?[^-]*$'\
      '';
      nsrr = "${rm} -v $(nsr)";
      nu = "${nix} flake update";
      nub = "nu && nrb";
      nubu = "nu && nrbu";
      nuc = "${nix} flake update --commit-lock-file";
      nui = "${nix} flake lock --update-input";
      nuic = "${nix} flake lock --commit-lock-file --update-input";
      nus = "nu && nrs";
      nut = "nu && nrt";
      nv = "echo '${
          __concatStringsSep "\n" (lib.mapAttrsToList (name: flake: ''
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
      du = "du -h";
      e = "run ${emacsclient} -c";
      et = "${emacsclient} -t";
      fm = "run ${vlc} http://fritz.box/dvb/m3u/radio.m3u";
      go = git-open;
      grl = "${git} reflog";
      grlp = "${git} reflog -p";
      gstlp = "${git} stash list -p";
      hc = hydra-check;
      hcs = "${hydra-check} --channel ${config.system.nixos.release}";
      inc = ''
        [ -n "$HISTFILE" ] && {
          echo "Enabled incognito mode"
          unset HISTFILE
        } || {
          echo "Disabled incognito mode"
          exec ${zsh}
        }
      '';
      ls = "ls -v --color=tty";
      lvl = "echo $SHLVL";
      mcd = f ''mkdir -p "$@" && cd "$1"'';
      msg = "${kdialog} --msgbox";
      nw = "whence -ps";
      o = xdg-open;
      p = "${pre-commit} run -a";
      qr = "${qrencode} -t UTF8";
      rb = "${shutdown} -r";
      rbc = "${shutdown} -c";
      rbn = "${shutdown} -r now";
      rgi = "${ripgrep} -i";
      rld = "exec ${zsh}";
      rldh = ''
        ${sudo} ${systemctl} restart 'home-manager-*.service'
        ${systemctl} status 'home-manager-*.service'\
      '';
      rldp = "${kquitapp5} plasmashell && ${kstart5} plasmashell";
      rmr = "rm -r";
      rn = pipe-rename;
      rna = "${pipe-rename} $(ls)";
      run = f ''"$@" &>/dev/null & disown'';
      sd = shutdown;
      sdc = "${shutdown} -c";
      sdn = "${shutdown} now";
      smart = "${sudo} ${smartmontools} -a";
      ssha = "${ssh} amethyst";
      sshb = "${ssh} beryl";
      sudo = "${sudo} ";
      t = tree;
      tv = "run ${vlc} http://fritz.box/dvb/m3u/{tvhd,tvsd}.m3u";
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

  # Disable the default `command-not-found` script (no flake support).
  programs.command-not-found.enable = false;
}
