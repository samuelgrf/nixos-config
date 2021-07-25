{ fetchurl, ... }: {

  home.file.".cache/nix-index/files".source = let release = "2021-07-25";
  in fetchurl {
    url =
      "https://github.com/Mic92/nix-index-database/releases/download/${release}/files";
    hash = "sha256-5eEipHcr4N8uTbIb3pPeRZKuHi36y44eSbzi92NOYDk=";
  };

}
