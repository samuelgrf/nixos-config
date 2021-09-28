{ fetchurl, ... }: {

  home.file.".cache/nix-index/files".source =
    fetchurl (import ./source.nix).src;

}
