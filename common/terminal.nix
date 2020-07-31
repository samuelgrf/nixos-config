{ config, pkgs, ... }:

{
  # Use X keyboard configuration on console.
  console.useXkbConfig = true;

  # Set Zsh as default shell.
  users.defaultUserShell = pkgs.zsh;

  # Configure Zsh.
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      package = pkgs.unstable.oh-my-zsh; # TODO Remove on 20.09.
      plugins = [ "git" ];
    };
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # Add entries to zshrc.
    interactiveShellInit = ''
      # Use powerlevel10k theme.
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Use Zsh instead of bash for nix-shell.
      # TODO Remove "unstable." on 20.09.
      source ${pkgs.unstable.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

      # Disable less history.
      export LESSHISTFILE=/dev/null

      # Define functions.
      emc () { emacsclient -c "$@" & }
      nw () { readlink $(where "$@") }
      smart () { sudo smartctl -a "$@" | less }
    '';

    # Set shell aliases.
    shellAliases = {
      # Nix & NixOS
      nc = "sudo nix-channel";
      nca = "sudo nix-channel --add";
      ncl = "sudo nix-channel --list";
      ncr = "sudo nix-channel --remove";
      ncro = "sudo nix-channel --rollback";
      ng = "sudo nix-collect-garbage";
      ngd = "sudo nix-collect-garbage -d";
      np = "nix repl '<nixpkgs>'";
      nr = "sudo nixos-rebuild";
      nrb = "sudo nixos-rebuild boot";
      nrbu = "nixos-rebuild build";
      nrs = "sudo nixos-rebuild switch";
      nrt = "sudo nixos-rebuild test";
      nu = "sudo nix-channel --update && sudo nixos-rebuild";
      nub = "sudo nix-channel --update && sudo nixos-rebuild boot";
      nubu = "sudo nix-channel --update && sudo nixos-rebuild build";
      nus = "sudo nix-channel --update && sudo nixos-rebuild switch";
      nut = "sudo nix-channel --update && sudo nixos-rebuild test";
      nse = "nix search";
      nsh = "nix-shell";
      nshp = "nix-shell -p";
      nsr = ''
        nix-store --gc --print-roots | \
          grep -Ev "^(/nix/var|/run/\w+-system|\{memory|\{censored)"\
      '';
      nv = "nixos-version";
      nvr = "nixos-version --revision";

      # Other
      inc = ''
        if [ -n "$HISTFILE" ]; then
          echo "Enabled incognito mode" &&
          unset HISTFILE
        else
          echo "Disabled incognito mode" &&
          exec zsh
        fi\
      '';
      lvl = "echo $SHLVL";
      rld = "exec zsh";
      wtr = "curl wttr.in";
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
}
