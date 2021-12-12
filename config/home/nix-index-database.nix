{ nix-index-database, ... }: {

  home.file.".cache/nix-index/files".source = nix-index-database;
}
