{ fetchurl, ... }: {

  home.file.".cache/nix-index/files".source = let release = "2021-07-18";
  in fetchurl {
    url =
      "https://github.com/Mic92/nix-index-database/releases/download/${release}/files";
    hash = "sha256-xxkILxe2YcguDY2hkIqi2tqLoru+NxeF/gjcBws3mzY=";
  };

}
