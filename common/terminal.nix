{ config, pkgs, ... }:

{
  # Use X keyboard configuration on console.
  console.useXkbConfig = true;

  # Set Zsh as default shell.
  users.defaultUserShell = pkgs.zsh;

  # Configure Zsh.
  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.package = pkgs.unstable.oh-my-zsh; # TODO Remove on 20.09.
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      # Use powerlevel10k theme.
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Use Zsh instead of bash for nix-shell.
      # TODO Remove "unstable." on 20.09
      source ${pkgs.unstable.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

      # Run nixos-rebuild as root and reload Zsh when needed.
      nixos-rebuild () {
        if [ "$1" = "switch" -o "$1" = "test" ]; then
          sudo nixos-rebuild "$@" &&
          exec zsh
        elif [ "$1" = "boot" ]; then
          sudo nixos-rebuild "$@"
        else
          command nixos-rebuild "$@"
        fi
      }

      # Run nix-collect-garbage as root when needed.
      nix-collect-garbage () {
        if [ "$1" = "-d" -o \
             "$1" = "--delete-old" -o \
             "$1" = "--delete-older-than" ]; then
          sudo nix-collect-garbage "$@"
        else
          command nix-collect-garbage "$@"
        fi
      }
    '';
    setOptions = [
      "HIST_FCNTL_LOCK"
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
    ];
  };

  # Set environment variables.
  environment.variables = {
    # Used for WIP changes (push changes to $SYSTEMCONFIG by running `applyconfig`).
    USERCONFIG = "/home/samuel/git-repos/nixconfig";
    # Used for finished configuration (set $USERCONFIG as remote).
    SYSTEMCONFIG = "/etc/nixos";
  };

  # Set shell aliases.
  environment.shellAliases = {
    # NixOS & Nix
    applyconfig = ''(
      cd $SYSTEMCONFIG &&
      sudo git fetch &&
      git diff master origin/master &&
      sudo git reset --hard origin/master)\
    '';
    testconfig = ''
      nixos-rebuild test \
        -I nixos-config=$USERCONFIG/configuration.nix\
    '';
    nixos-upgrade = ''
      sudo nix-channel --update &&
      nixos-rebuild\
    '';
    nix-stray-roots = ''
      nix-store --gc --print-roots | \
        grep -Ev "^(/nix/var|/run/\w+-system|\{memory|\{censored)"\
    '';
    pks = "nix search";

    # Other
    incognito = ''
      if [ -n "$HISTFILE" ]; then
        echo "Enabled incognito mode" &&
        unset HISTFILE
      else
        echo "Disabled incognito mode" &&
        exec zsh
      fi\
    '';
    level = "echo $SHLVL";
    reload = "exec zsh";
    wttr = "curl wttr.in";
  };
}
