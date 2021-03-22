{ fetchzip, ... }: {

  # Install GloriousEggroll's custom Proton build.
  home.file.".local/share/Steam/compatibilitytools.d/Proton-GE".source =
    let version = "6.4-GE-1";
    in fetchzip {
      url =
        "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/Proton-${version}.tar.gz";
      hash = "sha256-vKDTuK3RhqmuTIwB3rDRgY/ki6kLZ/RsfHJszN1ADlM=";
    };

}
