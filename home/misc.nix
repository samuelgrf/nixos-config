{
  home.file = {

    # Expose Nixpkgs config to Nix tools (requires `--impure` flag).
    ".config/nixpkgs/config.nix".source = ../main/nixpkgs.nix;

    # Force Plasma to use system locale settings.
    ".config/plasma-localerc".text = "";
  };
}
