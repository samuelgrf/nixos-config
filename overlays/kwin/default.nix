_: prev:
with prev;

# Patch files can be found here: https://tildearrow.org/storage/kwin-lowlatency
let
  version = "5.18.5";
  revision = "3";

  urlSuffix = version + lib.optionalString (revision != "0") "-${revision}";
in {

  plasma5 = plasma5 // {

    kwin = plasma5.kwin.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [
        (fetchpatch {
          url =
            "https://tildearrow.org/storage/kwin-lowlatency/kwin-lowlatency-${urlSuffix}.patch";
          sha256 = "sha256-HaHw7CDayhtlTA8qs8maUsz4qjHTVUsYaFg9IFxjGhM=";
        })
      ];

      meta.broken = (lib.getVersion plasma5.kwin) != version;
    });

  };

}
