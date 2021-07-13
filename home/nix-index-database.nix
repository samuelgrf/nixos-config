{ fetchurl, ... }: {

  home.file.".cache/nix-index/files".source = let release = "2021-07-11";
  in fetchurl {
    url =
      "https://github.com/Mic92/nix-index-database/releases/download/${release}/files";
    hash = "sha256-poDNvDPXDpKa04Uxq6a9ds5cANztb2YE7/yxyznMfvA=";
  };

}
