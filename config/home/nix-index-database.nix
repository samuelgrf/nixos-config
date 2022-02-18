{ pkgs, ... }: {

  home.file.".cache/nix-index/files".source = pkgs.nix-index-database;
}
