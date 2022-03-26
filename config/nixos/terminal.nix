{ config, flakes, lib, pkgs, ... }:

with pkgs; {

  # Use X keyboard configuration on console.
  console.useXkbConfig = true;

  # Set Zsh as default shell.
  users.defaultUserShell = zsh;

  # /etc/zshrc
  environment.etc.zshrc.text = lib.mkMerge [
    ''
      # Load and configure Powerlevel10k theme.
      source ${zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${zsh-powerlevel10k}/share/zsh-powerlevel10k/config/p10k-lean.zsh
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

      # Use I-Beam shaped cursor.
      _set_cursor_shape() { printf '\e[5 q' }
      precmd_functions+=(_set_cursor_shape)

      # Load Fast Syntax Highlighting.
      source ${zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

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
    configDir = ''$(dirname "$(realpath /etc/nixos/flake.nix)")'';
    docDir = "/run/current-system/sw/share/doc";
  in {
    enable = true;
    setOptions = [ "AUTO_CONTINUE" "HIST_FCNTL_LOCK" ];

    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git" ];
    autosuggestions.enable = true;

    # Set shell aliases.
    shellAliases = let f = x: "f() { ${x} }; f";
    in {

      # Nix & NixOS
      c = ''cd "${configDir}"'';
      hmm = "o '${docDir}/home-manager/index.html'";
      hmo = "${man.exe} home-configuration.nix";
      n = config.nix.package.exe;
      nb = "n build --print-build-logs -v";
      "nb!" = "sudo nb --max-jobs 0 --builders ssh-ng://beryl";
      "nb!a" = "sudo nb --max-jobs 0 --builders ssh-ng://amethyst";
      nbd = "nb --dry-run -v";
      nd = "n develop";
      ne = f ''
        n eval --impure --expr "with import ${configDir}/repl.nix; $@" \
          | ${gnused.exe} 's/^"\(.*\)"$/\1/'
      '';
      nf = "n flake";
      nfc = "nf check";
      nfl = "nf lock";
      nfu = "nu";
      nfuc = "nuc";
      nfui = "nui";
      nfuic = "nuic";
      ngd = "n path-info --derivation";
      nlg = "n log";
      nlo = "${nix-index}/bin/nix-locate";
      nm = "o '${docDir}/nix/manual/index.html'";
      nom = "o '${docDir}/nixos/index.html'";
      noo = "${man.exe} configuration.nix";
      np = ''npl "${configDir}/repl.nix"'';
      npl = "n repl";
      npm = "o '${docDir}/nixpkgs/manual.html'";
      nr = f ''
        (set -eo pipefail

        oldNixosGen="$(realpath '/run/current-system')"
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

        sudo ${config.system.build.nixos-rebuild}/bin/nixos-rebuild -v "''${origArgs[@]}"

        if [ -z "$targetHost" ]; then
          if [[ "$action" = boot || "$action" = switch ]]; then
            newNixosGen="$(realpath '/nix/var/nix/profiles/system')"
            ${nvd.exe} diff "$oldNixosGen" "$newNixosGen"
          elif [ -z "$buildHost" ]; then
            newNixosGen="$(realpath 'result')"
            ${nvd.exe} diff "$oldNixosGen" "$newNixosGen"
          fi
        fi)
      '';
      "nr!" = "nr --build-host beryl";
      "nr!a" = "nr --build-host amethyst";
      nrb = "nr boot";
      "nrb!" = "nr! boot";
      "nrb!a" = "nr!a boot";
      nrbu = "nr build";
      "nrbu!" = "nr! build";
      "nrbu!a" = "nr!a build";
      nrn = f ''
        (set -eo pipefail

        attrs=$(nlo --top-level --minimal --at-root --whole-name "/bin/$1")

        [ -z "$flake" ] && flake=nixpkgs

        if [ "$attrs" ]; then
          attr=$(echo "$attrs" | ${fzy.exe} -l 100)
          n shell "$flake#$attr" --command "$@"
        else
          >&2 echo "command not found: $1"
          exit 1
        fi)
      '';
      nrnm = "flake=github:NixOS/nixpkgs; nrn";
      nrnu = "flake=nixpkgs-unstable; nrn";
      nrs = f ''nr switch "$@" && rld'';
      "nrs!" = f ''nr! switch "$@" && rld'';
      "nrs!a" = f ''nr!a switch "$@" && rld'';
      nrt = f ''nr test "$@" && rld'';
      "nrt!" = f ''nr! test "$@" && rld'';
      "nrt!a" = f ''nr!a test "$@" && rld'';
      nsd = f ''n show-derivation "$@" | b -l json'';
      nse = "n search nixpkgs";
      nsem = "n search github:NixOS/nixpkgs";
      nseu = "n search nixpkgs-unstable";
      nsh = f ''n shell nixpkgs#"$@"'';
      nshm = f ''n shell github:NixOS/nixpkgs#"$@"'';
      nshu = f ''n shell nixpkgs-unstable#"$@"'';
      nsr = ''
        ${config.nix.package.exe}-store --gc --print-roots \
          | cut -f 1 -d " " \
          | ${gnugrep.exe} '/result-\?[^-]*$'
      '';
      nsrr = "rm -v $(nsr)";
      nu = "nf update";
      nub = "nu && nrb";
      "nub!" = "nu && nrb!";
      "nub!a" = "nu && nrb!a";
      nubu = "nu && nrbu";
      "nubu!" = "nu && nrbu!";
      "nubu!a" = "nu && nrbu!a";
      nuc = "nu --commit-lock-file";
      nui = "nfl --update-input";
      nuic = "nfl --commit-lock-file --update-input";
      nus = "nu && nrs";
      "nus!" = "nu && nrs!";
      "nus!a" = "nu && nrs!a";
      nut = "nu && nrt";
      "nut!" = "nu && nrt!";
      "nut!a" = "nu && nrt!a";
      nv = "echo '${
          __concatStringsSep "\n" (lib.mapAttrsToList (name: flake: ''
            ${name}:
              ${flake.rev or "dirty"} (${
                lib.formatDateSep "-" flake.lastModifiedDate or "19700101"
              })'') flakes)
        }'";

      # Other
      b = bat.exe;
      bat = ''b --wrap=never --pager="${less.exe} $LESS"'';
      clean = ''
        sudo systemctl start nix-gc.service
        journalctl -o cat -fu nix-gc.service
      '';
      cpr = "cp -r";
      du = "du -h";
      dso = "disown";
      e = "run ${config.services.emacs.package.exe}client -c";
      et = "${config.services.emacs.package.exe}client -t";
      fm = "run ${vlc.exe} http://fritz.box/dvb/m3u/radio.m3u";
      g = config.programs.git.package.exe;
      go = git-open.exe;
      grl = "g reflog";
      grlp = "g reflog -p";
      gstlp = "g stash list -p";
      hc = python3Packages.hydra-check.exe;
      hcs = "hc --channel ${config.system.nixos.release}";
      inc = ''
        [ -n "$HISTFILE" ] && {
          echo "Enabled incognito mode"
          unset HISTFILE
        } || {
          echo "Disabled incognito mode"
          rld
        }
      '';
      ls = "ls -v --color=tty";
      lvl = "echo $SHLVL";
      mcd = f ''mkdir -p "$@" && cd "$1"'';
      msg = "${plasma5Packages.kdialog.exe} --msgbox";
      nw = "whence -ps";
      o = "${xdg-utils}/bin/xdg-open";
      p = "${pre-commit.exe} run --files $(git diff HEAD --name-only)";
      qr = "${qrencode.exe} -t UTF8";
      rb = "sd -r";
      rbc = "sd -c";
      rbn = "sd -r now";
      rgi = "${ripgrep.exe} -i";
      rld = "exec ${zsh.exe}";
      rldh = ''
        sudo systemctl restart 'home-manager-*.service'
        systemctl status 'home-manager-*.service'
      '';
      rldp = ''
        ${plasma5Packages.kdbusaddons}/bin/kquitapp5 plasmashell &&
        ${plasma5Packages.kdbusaddons}/bin/kstart5 plasmashell
      '';
      rmr = "rm -r";
      rn = pipe-rename.exe;
      rna = "rn .";
      run = f ''"$@" &>/dev/null & dso'';
      sd = "shutdown";
      sdc = "sd -c";
      sdn = "sd now";
      smart = "sudo ${smartmontools.exe} -a";
      ssha = "${config.programs.ssh.package.exe} amethyst";
      sshb = "${config.programs.ssh.package.exe} beryl";
      sshp = "${config.programs.ssh.package.exe} pi@nextcloudpi";
      sudo = "${config.security.wrapperDir}/sudo";
      t = tree.exe;
      tv = "run ${vlc.exe} http://fritz.box/dvb/m3u/{tvhd,tvsd}.m3u";
      watch = "${procps}/bin/watch ";
      wtr = "${curl.exe} wttr.in";
      zl = "${config.boot.zfs.package.exe} list";
      zla = "zl -t all";
      zlf = "zl -t filesystem";
      zls = "zl -t snapshot";
      zlv = "zl -t volume";
      zp = "${config.boot.zfs.package}/bin/zpool";
      zs = "sudo systemctl start zfs-scrub.service && watch zst";
      zsc = "sudo zp scrub -s rpool; zst";
      zst = "zp status -t rpool";
      zt = "sudo systemctl start zpool-trim.service && watch zst";
      ztc = "sudo zp trim -c rpool; zst";
    };
  };

  # Disable the default `command-not-found` script (no flake support).
  programs.command-not-found.enable = false;
}
