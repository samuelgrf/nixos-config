{ fetchzip, ... }: {

  # Install GloriousEggroll's custom Proton build.
  home.file.".local/share/Steam/compatibilitytools.d/Proton-GE".source =
    let version = "6.5-GE-1";
    in fetchzip {
      url =
        "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/Proton-${version}.tar.gz";
      hash = "sha256-8rjSLJY83R1PIqMSsCAbkVwS40WYf/aRQtZqW44yGMQ=";
    };

}
