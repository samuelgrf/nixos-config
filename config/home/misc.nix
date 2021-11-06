{
  # Expose Nixpkgs config to Nix tools (requires `--impure` flag).
  home.file.".config/nixpkgs/config.nix".source = ../shared/nixpkgs.nix;
}
