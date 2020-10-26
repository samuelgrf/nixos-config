{ pkgs, ... }:

{
  # Use X keyboard configuration on console.
  console.useXkbConfig = true;

  # Set Zsh as default shell.
  users.defaultUserShell = pkgs.zsh;

  # Configure Zsh.
  programs.zsh = rec {
    enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git" ];
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # Add entries to zshrc.
    interactiveShellInit = with shellAliases; ''
      # Use powerlevel10k theme.
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Use Zsh instead of bash for nix-shell.
      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

      # Load the nix-index `command-not-found` replacement.
      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

      # Automatically generate completions based on `--help` output.
      source <(cod init $$ zsh)

      # Disable less history.
      export LESSHISTFILE=/dev/null

      # Define Nix & NixOS functions.
      nrs () { sudo nixos-rebuild -v "$@" switch && exec zsh }
      nrt () { sudo nixos-rebuild -v "$@" test && exec zsh }
      nsh () { NIXPKGS_ALLOW_UNFREE=1 nix shell --impure nixpkgs#"$@" }
      nshm () { NIXPKGS_ALLOW_UNFREE=1 nix shell --impure nixpkgs-master#"$@" }
      nshu () { NIXPKGS_ALLOW_UNFREE=1 nix shell --impure nixpkgs-unstable#"$@" }
      nus () { ${nu} && sudo nixos-rebuild -v "$@" switch && exec zsh }
      nut () { ${nu} && sudo nixos-rebuild -v "$@" test && exec zsh }
      nw () { readlink $(where "$@") }
      run () { NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#"$@" }
      runm () { NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs-master#"$@" }
      runu () { NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs-unstable#"$@" }

      # Define other functions.
      e () { emacsclient -c "$@" > /dev/null & disown }
      et () { emacsclient -t "$@" }
      smart () { sudo smartctl -a "$@" | less }
    '';

    # Set shell aliases.
    shellAliases = {
      # Nix & NixOS
      n = "nix";
      nb = "NIXPKGS_ALLOW_UNFREE=1 nix build --impure --print-build-logs -vf";
      nf = "nix flake";
      nfc = "nix flake check";
      nfu = "nix flake update";
      ng = "nix-collect-garbage";
      ngd = "sudo nix-collect-garbage -d";
      nlo = "nix-locate";
      np = "nix repl";
      nrb = "sudo nixos-rebuild -v boot";
      nrbu = "nixos-rebuild -v build";
      nse = "nix search nixpkgs";
      nsem = "nix search nixpkgs-master";
      nseu = "nix search nixpkgs-unstable";
      nsr = ''
        nix-store --gc --print-roots | \
          grep -Ev "^(/nix/var|/run/\w+-system|\{memory|\{censored)"\
      '';
      nu = ''
        [ -d /etc/nixos ] && cd /etc/nixos
        nix flake update --recreate-lock-file --commit-lock-file\
      '';
      nub = "nu && sudo nixos-rebuild -v boot";
      nubu = "nu && sudo nixos-rebuild -v build";
      nv = "nixos-version";
      nvr = "nixos-version --revision";

      # Other
      grl = "git reflog";
      inc = ''
        [ -n "$HISTFILE" ] && {
          echo "Enabled incognito mode" &&
          unset HISTFILE
        } || {
          echo "Disabled incognito mode" &&
          exec zsh
        }\
      '';
      lvl = "echo $SHLVL";
      msg = "kdialog --msgbox";
      o = "xdg-open";
      qr = "qrencode -t UTF8";
      rb = "shutdown -r";
      rbc = "shutdown -c";
      rbn = "shutdown -r now";
      rld = "exec zsh";
      sd = "shutdown";
      sdc = "shutdown -c";
      sdn = "shutdown now";
      wtr = "curl wttr.in";
      ztr = "sudo zpool trim rpool && watch zpool status -t rpool";
    };

    # Set Zsh options.
    setOptions = [
      "HIST_FCNTL_LOCK"
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
    ];
  };

  # Override Oh My Zsh defaults.
  environment.extraInit = "export LESS='-i -F -R'";

  # Disable the default `command-not-found` script (no flake support).
  programs.command-not-found.enable = false;
}
