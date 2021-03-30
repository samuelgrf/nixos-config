_: prev:
with prev; {

  # Patch files can be found here: https://tildearrow.org/storage/kwin-lowlatency
  plasma5 = plasma5 // {

    kwin = plasma5.kwin.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [
        (fetchpatch {
          url =
            "https://tildearrow.org/storage/kwin-lowlatency/kwin-lowlatency-5.18.5-3.patch";
          sha256 = "sha256-HaHw7CDayhtlTA8qs8maUsz4qjHTVUsYaFg9IFxjGhM=";
        })
      ];
    });

  };

}
