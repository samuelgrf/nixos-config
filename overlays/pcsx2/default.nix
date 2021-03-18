_: prev: {

  pcsx2 = (prev.pcsx2.override {
    stdenv = (prev.impureUseNativeOptimizations prev.stdenv);
  })

    .overrideAttrs (oldAttrs: {
      cmakeFlags =
        prev.lib.remove "-DDISABLE_ADVANCE_SIMD=TRUE" oldAttrs.cmakeFlags;
    });

}
