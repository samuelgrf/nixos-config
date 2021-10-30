{
  home.file = {

    # Expose Nixpkgs config to Nix tools (requires `--impure` flag).
    ".config/nixpkgs/config.nix".source = ../main/nixpkgs.nix;

    # Force Plasma to use system locale settings.
    ".config/plasma-localerc".text = "";
    ".config/plasma-localerc".force = true;
  };

  # Force overwrite symlinks that KDE replaces with new files.
  xdg = {
    configFile."fontconfig/conf.d/10-hm-fonts.conf".force = true;
    configFile."mimeapps.list".force = true;
    dataFile."applications/mimeapps.list".force = true;
  };
}
