_: prev:
with prev; {

  pcsx2 = (pcsx2.override { stdenv = (impureUseNativeOptimizations stdenv); })

    .overrideAttrs (oldAttrs: {
      cmakeFlags = lib.remove "-DDISABLE_ADVANCE_SIMD=TRUE" oldAttrs.cmakeFlags;
    });

}
