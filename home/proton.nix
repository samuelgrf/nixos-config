{ pkgs, ... }:

{
  # Install GloriousEggroll's custom Proton build.
  home.file.".local/share/Steam/compatibilitytools.d/Proton-GE".source = let
    version = "6.1-GE-1";
  in pkgs.fetchzip {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/Proton-${version}.tar.gz";
    hash = "sha256-S1buBkL2xdk+zUkJcMcb84q8wwVkSxtQVtrbT/KmgTk=";
  };
}
